//
//  LNRSimpleNotifications
//
//  LNRSimpleNotifications: Modifications of TSMessages Copyright (c) 2015 LISNR, inc.
//  TSMessages: Copyright (c) 2014 Toursprung, Felix Krause <krausefx@gmail.com>
//

import UIKit
import AudioToolbox

public typealias LNRNotificationOperationCompletionBlock = (Void) -> Void

let kLNRNotificationAnimationDuration = 0.3

/**
 *  Define whether a notification view should be displayed at the top of the screen or the bottom of the screen
 */
public enum LNRNotificationPosition {
    case top //Default position
    case bottom
}

/**
 *  Enum values can be passed to the duration parameter using syntax 'LNRNotificationDuration.Automatic.rawValue()'
 */
public enum LNRNotificationDuration: TimeInterval {
    case `default` = 3.0 // Default is 3 seconds.
    case endless = -1.0 // Notification is displayed until it is dismissed by calling dismissActiveNotification
}

public class LNRNotificationManager: NSObject {
    
    /** Shows a notification
     *  @param title The title of the notification view
     *  @param body The text that is displayed underneath the title
     *  @param onTap The block that should be executed when the user taps on the notification
     */
    public func showNotification(title: String, body: String?, onTap: LNRNotificationOperationCompletionBlock?) {
        DispatchQueue.main.async {
            if self.isNotificationActive {
                let _ = self.dismissActiveNotification(completion: { () -> Void in
                    self.showNotification(title: title, body: body, onTap: onTap)
                })
            } else {
                let notification = LNRNotificationView(title: title, body: body, icon: self.notificationsIcon, duration: self.notificationsDefaultDuration, onTap: onTap, position: self.notificationsPosition, notificationManager: self)
                self.displayNotification(notification: notification)
            }
        }
    }
    
    /** Dismisses the currently displayed notification with a completion block called after the notification disappears off screen
     *  @param completion The block that should be executed when the notification finishes dismissing
     *  @return true if notification dismissal was triggered, false if no notification was currently displayed.
     */
    public func dismissActiveNotification(completion: LNRNotificationOperationCompletionBlock?) -> Bool {
        
        if isNotificationActive {
            return self.dismissNotification(notification: self.activeNotification!, dismissAnimationCompletion: { () -> Void in
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
    public func dismissNotification(notification: LNRNotificationView, dismissAnimationCompletion:LNRNotificationOperationCompletionBlock?) -> Bool {
        
        if notification.isDisplayed {
            var offScreenPoint: CGPoint
            
            if notification.position != LNRNotificationPosition.bottom {
                offScreenPoint = CGPoint(x: notification.center.x, y: -(notification.frame.height / 2.0))
            } else {
                offScreenPoint = CGPoint(x: notification.center.x, y: (UIScreen.main.bounds.size.height + notification.frame.height / 2.0))
            }
            
            UIView.animate(withDuration: kLNRNotificationAnimationDuration, animations: { () -> Void in
                notification.center = offScreenPoint
            })
            
            // Using a dispatch_after block to perform tasks after animation completion tasks because UIView's animateWithDuration:animations:completion: completion callback gets called immediatly due to the dismissNotification:dismissAnimationCompletion: method being called from within a dispatch_after block.
            let delayTime = DispatchTime.now() + Double(Int64(kLNRNotificationAnimationDuration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [unowned self] () -> Void in
                
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
    public var activeNotification: LNRNotificationView?
    
    // MARK: Notification Styling
    
    /**
    *  Use to set the background color of notifications.
    */
    public var notificationsBackgroundColor: UIColor = UIColor.white
    
    /**
     *  Use to set the title text color of notifications
     */
    public var notificationsTitleTextColor: UIColor = UIColor.black
    
    /**
     *  Use to set the body text color of notifications.
     */
    public var notificationsBodyTextColor: UIColor = UIColor.black
    
    /**
     *  Use to set the title font of notifications.
     */
    public var notificationsTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 14.0)
    
    /**
     *  Use to set the body font of notifications.
     */
    public var notificationsBodyFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    
    /**
     *  Use to set the bottom/top seperator color.
     */
    public var notificationsSeperatorColor: UIColor = UIColor.clear
    
    /**
     *  Use to set the icon displayed with notifications.
     */
    public var notificationsIcon: UIImage?
    
    /**
     *  Use to set the duration notifications are displayed.
     */
    public var notificationsDefaultDuration: TimeInterval = LNRNotificationDuration.default.rawValue
    
    /**
     *  Use to set the position of notifications on screen.
     */
    public var notificationsPosition: LNRNotificationPosition = LNRNotificationPosition.top
    
    /**
     *  Use to set the system sound played when a a notification is displayed.
     */
    public var notificationSound: SystemSoundID?
    
    // MARK: Internal
    
    private func displayNotification(notification: LNRNotificationView) {
        
        self.activeNotification = notification
        
        notification.isDisplayed = true
        
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(notification)
        
        var toPoint: CGPoint
        
        if notification.position != LNRNotificationPosition.bottom {
            toPoint = CGPoint(x: notification.center.x, y: notification.frame.height / 2.0)
        } else {
            let y: CGFloat = UIScreen.main.bounds.size.height - (notification.frame.height / 2.0)
            toPoint = CGPoint(x: notification.center.x, y: y)
        }
        
        if let notificationSound = notificationSound {
            AudioServicesPlayAlertSound(notificationSound)
        }
        
        UIView.animate(withDuration: kLNRNotificationAnimationDuration + 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction], animations: { () -> Void in
            notification.center = toPoint
            }, completion: nil)
        
        if notification.duration != LNRNotificationDuration.endless.rawValue {
            let notificationDisplayTime = notification.duration > 0 ? notification.duration : LNRNotificationDuration.default.rawValue
            let delayTime = DispatchTime.now() + Double(Int64(notificationDisplayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [unowned self] () -> Void in
                let _ = self.dismissNotification(notification: notification, dismissAnimationCompletion: nil)
            })
        }
        
    }
    
}
