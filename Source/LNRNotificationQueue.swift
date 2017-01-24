//
//  LNRSimpleNotifications
//
//  LNRSimpleNotifications: Modifications of TSMessages Copyright (c) 2015 LISNR, inc.
//  TSMessages: Copyright (c) 2014 Toursprung, Felix Krause <krausefx@gmail.com>
//

import UIKit

public class LNRNotificationQueue: NSObject {

    fileprivate let notificationManager: LNRNotificationManager!
    
    /**
     *  Initializes a LNRNotificationQueue
     * 
     *  @param notificationManager The LNRNotificationManager that will be used to display queued messages. You should not trigger notifications from this Notification Manager anywhere else in your app.
     */
    public init(notificationManager: LNRNotificationManager) {
        self.notificationManager = notificationManager
    }
    
    /**
     *  Queues a notification to be displayed.
     */
    public func queueNotification(notification: LNRNotification) {
        if notificationManager.isNotificationActive {
            notificationQueue.append(notification)
        } else {
            queueLock.lock()
            notificationQueue.append(notification)
            queueLock.unlock()
            showNextQueuedNotification()
        }
    }
    
    fileprivate func showNextQueuedNotification() {
        queueLock.lock()
        if let nextNotification = notificationQueue.first {
            notificationQueue.removeFirst()
            let optionalProvidedOnTap = nextNotification.onTap
            let optionalProvidedOnTimeout = nextNotification.onTimeout
            nextNotification.onTap = { [unowned self] () -> Void in
                if let providedOnTap = optionalProvidedOnTap {
                    providedOnTap()
                }
                self.showNextQueuedNotification()
            }
            nextNotification.onTimeout = { [unowned self] () -> Void in
                if let providedOnTimeout = optionalProvidedOnTimeout {
                    providedOnTimeout()
                }
                self.showNextQueuedNotification()
            }
            notificationManager.showNotification(notification: nextNotification)
        }
        
        queueLock.unlock()
    }
    
    fileprivate var notificationQueue = [LNRNotification]()
    fileprivate let queueLock = NSLock()
    
}
