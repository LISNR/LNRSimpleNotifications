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
    public func showNotification(notification: LNRNotification) {
        DispatchQueue.main.async {
            if self.isNotificationActive {
                let _ = self.dismissActiveNotification(completion: { () -> Void in
                    self.showNotification(notification: notification)
                })
            } else {
                let notificationView = LNRNotificationView(notification: notification, icon: self.notificationsIcon, notificationManager: self)
                self.displayNotificationView(notificationView: notificationView)
            }
        }
    }
    
    /** Dismisses the currently displayed notificationView with a completion block called after the notification disappears off screen
     *  @param completion The block that should be executed when the notification finishes dismissing
     *  @return true if notification dismissal was triggered, false if no notification was currently displayed.
     */
    public func dismissActiveNotification(completion: LNRNotificationOperationCompletionBlock?) -> Bool {
        
        if isNotificationActive {
            return self.dismissNotificationView(notificationView: self.activeNotification!, dismissAnimationCompletion: { () -> Void in
                self.activeNotification = nil
                if completion != nil {
                    completion!()
                }
            })
        }
        
        return false
    }
    
    /** Dismisses the notificationView passed as an argument
     *  @param dismissAnimationCompletion The block that should be executed when the notification finishes dismissing
     *  @return true if notification dismissal was triggered, false if notification was not currently displayed.
     */
    public func dismissNotificationView(notificationView: LNRNotificationView, dismissAnimationCompletion:LNRNotificationOperationCompletionBlock?) -> Bool {
        
        if notificationView.isDisplayed {
            var offScreenPoint: CGPoint
            
            if notificationsPosition != LNRNotificationPosition.bottom {
                offScreenPoint = CGPoint(x: notificationView.center.x, y: -(notificationView.frame.height / 2.0))
            } else {
                offScreenPoint = CGPoint(x: notificationView.center.x, y: (UIScreen.main.bounds.size.height + notificationView.frame.height / 2.0))
            }
            
            UIView.animate(withDuration: kLNRNotificationAnimationDuration, animations: { () -> Void in
                notificationView.center = offScreenPoint
            })
            
            // Using a dispatch_after block to perform tasks after animation completion tasks because UIView's animateWithDuration:animations:completion: completion callback gets called immediatly due to the dismissNotificationView:dismissAnimationCompletion: method being called from within a dispatch_after block.
            let delayTime = DispatchTime.now() + Double(Int64(kLNRNotificationAnimationDuration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [unowned self] () -> Void in
                
                notificationView.removeFromSuperview()
                notificationView.isDisplayed = false
                
                if self.activeNotification == notificationView {
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
     *  Use to set the position of notifications on screen.
     */
    public var notificationsPosition: LNRNotificationPosition = LNRNotificationPosition.top
    
    /**
     *  Use to set the system sound played when a a notification is displayed.
     */
    public var notificationSound: SystemSoundID?
    
    // MARK: Internal
    
    private func displayNotificationView(notificationView: LNRNotificationView) {
        
        self.activeNotification = notificationView
        
        notificationView.isDisplayed = true
        
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(notificationView)
        
        var toPoint: CGPoint
        
        if notificationsPosition != LNRNotificationPosition.bottom {
            toPoint = CGPoint(x: notificationView.center.x, y: notificationView.frame.height / 2.0)
        } else {
            let y: CGFloat = UIScreen.main.bounds.size.height - (notificationView.frame.height / 2.0)
            toPoint = CGPoint(x: notificationView.center.x, y: y)
        }
        
        if let notificationSound = notificationSound {
            AudioServicesPlayAlertSound(notificationSound)
        }
        
        UIView.animate(withDuration: kLNRNotificationAnimationDuration + 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction], animations: { () -> Void in
            notificationView.center = toPoint
            }, completion: nil)
        
        if notificationView.notification.duration != LNRNotificationDuration.endless.rawValue {
            let notificationDisplayTime = notificationView.notification.duration > 0 ? notificationView.notification.duration : LNRNotificationDuration.default.rawValue
            let delayTime = DispatchTime.now() + Double(Int64(notificationDisplayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [unowned self] () -> Void in
                let dismissed = self.dismissNotificationView(notificationView: notificationView, dismissAnimationCompletion: nil)
                if dismissed {
                    if let onTimeout = notificationView.notification.onTimeout {
                        onTimeout()
                    }
                }
            })
        }
        
    }
    
}
