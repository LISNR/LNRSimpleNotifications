//
//  LNRSimpleNotifications
//
//  LNRSimpleNotifications: Modifications of TSMessages Copyright (c) 2015 LISNR, inc.
//  TSMessages: Copyright (c) 2014 Toursprung, Felix Krause <krausefx@gmail.com>
//

import UIKit
import AudioToolbox

public typealias LNRSimpleNotificationsCompletionBlock = Void -> Void

let kLNRNotificationAnimationDuration = 0.3

/**
*  Define whether a notification view should be displayed at the top of the screen or the bottom of the screen
*/
public enum LNRNotificationPosition {
    case Top //Default position
    case Bottom
}

/**
*  Enum values can be passed to the duration parameter using syntax 'LNRNotificationDuration.Automatic.rawValue()'
*/
public enum LNRNotificationDuration: NSTimeInterval {
    case Default = 3.0 // Default is 3 seconds.
    case Endless = -1.0 // Notification is displayed until it is dismissed by calling dismissActiveNotification
}

public class LNRSimpleNotifications: NSObject {
    
    /**
    *  Returns the Notification Manager singleton
    */
    public static let sharedNotificationManager = LNRSimpleNotifications()
    
    /** Shows a notification
    *  @param title The title of the notification view
    *  @param body The text that is displayed underneath the title
    *  @param callback The block that should be executed when the user taps on the notification
    */
    public func showNotification(title: String, body: String?, callback: LNRSimpleNotificationsCompletionBlock?) {
        dispatch_async(dispatch_get_main_queue()) {
            if self.isNotificationActive {
                self.dismissActiveNotification( { () -> Void in
                    self.showNotification(title, body: body, callback: callback)
                })
            } else {
                let notification = LNRSimpleNotificationView(title: title, body: body, icon: self.notificationsIcon, duration: self.notificationsDefaultDuration, callback: callback, position: self.notificationsPosition)
                self.displayNotification(notification)
            }
        }
    }
    
    /** Dismisses the currently displayed notification with a completion block called after the notification disappears off screen
    *  @param completion The block that should be executed when the notification finishes dismissing
    *  @return true if notification dismissal was triggered, false if no notification was currently displayed.
    */
    public func dismissActiveNotification(completion: LNRSimpleNotificationsCompletionBlock?) -> Bool {
        
        if isNotificationActive {
            return self.dismissNotification(self.activeNotification!, dismissAnimationCompletion: { () -> Void in
                self.activeNotification = nil
                if completion != nil {
                    completion!()
                }
            })
        }
        
        return false
    }
    
    /** Dismisses the notification passed as an argument
    *  @param dismissAnimationCompletion The block that should be executed when the notification finishes dismissing
    *  @return true if notification dismissal was triggered, false if notification was not currently displayed.
    */
    public func dismissNotification(notification: LNRSimpleNotificationView, dismissAnimationCompletion:LNRSimpleNotificationsCompletionBlock?) -> Bool {
        
        if notification.isDisplayed {
            var offScreenPoint: CGPoint
            
            if notification.position != LNRNotificationPosition.Bottom {
                offScreenPoint = CGPoint(x: notification.center.x, y: -(CGRectGetHeight(notification.frame) / 2.0))
            } else {
                offScreenPoint = CGPoint(x: notification.center.x, y: (UIScreen.mainScreen().bounds.size.height + CGRectGetHeight(notification.frame) / 2.0))
            }
            
            UIView.animateWithDuration(kLNRNotificationAnimationDuration, animations: { () -> Void in
                notification.center = offScreenPoint
            })
            
            // Using a dispatch_after block to perform tasks after animation completion tasks because UIView's animateWithDuration:animations:completion: completion callback gets called immediatly due to the dismissNotification:dismissAnimationCompletion: method being called from within a dispatch_after block.
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(kLNRNotificationAnimationDuration * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), { [unowned self] () -> Void in
                
                notification.removeFromSuperview()
                notification.isDisplayed = false
                
                if self.activeNotification == notification {
                    self.activeNotification = nil
                }
                
                if dismissAnimationCompletion != nil {
                    dismissAnimationCompletion!()
                }
            })
            
            return true
        }
        
        return false
    }

    /**
    *  Indicates whether a notification is currently active.
    *
    *  @return true if a notification is being displayed
    */
    public var isNotificationActive: Bool {
        return (self.activeNotification != nil)
    }
    
    /**
    *  The active notification, if there is one. nil if no notification is currently active.
    */
    public var activeNotification: LNRSimpleNotificationView?
    
    // MARK: Notification Styling
    
    /**
    *  Use to set the background color of notifications.
    */
    public var notificationsBackgroundColor: UIColor = UIColor.whiteColor()
    
    /**
    *  Use to set the title text color of notifications
    */
    public var notificationsTitleTextColor: UIColor = UIColor.blackColor()
    
    /**
    *  Use to set the body text color of notifications.
    */
    public var notificationsBodyTextColor: UIColor = UIColor.blackColor()
    
    /**
    *  Use to set the title font of notifications.
    */
    public var notificationsTitleFont: UIFont = UIFont.boldSystemFontOfSize(14.0)
    
    /**
    *  Use to set the body font of notifications.
    */
    public var notificationsBodyFont: UIFont = UIFont.systemFontOfSize(12.0)
    
    /**
    *  Use to set the bottom/top seperator color.
    */
    public var notificationsSeperatorColor: UIColor = UIColor.clearColor()
    
    /**
    *  Use to set the icon displayed with notifications.
    */
    public var notificationsIcon: UIImage?
    
    /**
    *  Use to set the duration notifications are displayed.
    */
    public var notificationsDefaultDuration: NSTimeInterval = LNRNotificationDuration.Default.rawValue
    
    /**
    *  Use to set the position of notifications on screen.
    */
    public var notificationsPosition: LNRNotificationPosition = LNRNotificationPosition.Top
    
    /**
    *  Use to set the system sound played when a a notification is displayed.
    */
    public var notificationSound: SystemSoundID?
    
    // MARK: Internal
    
    private func displayNotification(notification: LNRSimpleNotificationView) {
        
        self.activeNotification = notification
        
        notification.isDisplayed = true
        
        let mainWindow = UIApplication .sharedApplication().keyWindow
        mainWindow?.addSubview(notification)
        
        var toPoint: CGPoint
        
        if notification.position != LNRNotificationPosition.Bottom {
            toPoint = CGPointMake(notification.center.x, CGRectGetHeight(notification.frame) / 2.0)
        } else {
            let y: CGFloat = UIScreen.mainScreen().bounds.size.height - (CGRectGetHeight(notification.frame) / 2.0)
            toPoint = CGPointMake(notification.center.x, y)
        }
        
        if let notificationSound = notificationSound {
            AudioServicesPlayAlertSound(notificationSound)
        }
        
        UIView.animateWithDuration(kLNRNotificationAnimationDuration + 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [UIViewAnimationOptions.CurveEaseInOut, UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.AllowUserInteraction], animations: { () -> Void in
            notification.center = toPoint
        }, completion: nil)
        
        if notification.duration != LNRNotificationDuration.Endless.rawValue {
            let notificationDisplayTime = notification.duration > 0 ? notification.duration : LNRNotificationDuration.Default.rawValue
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(notificationDisplayTime * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), { [unowned self] () -> Void in
                self.dismissNotification(notification, dismissAnimationCompletion: nil)
            })
        }

    }
    
}