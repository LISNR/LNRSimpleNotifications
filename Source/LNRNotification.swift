//
//  LNRSimpleNotifications
//
//  LNRSimpleNotifications: Modifications of TSMessages Copyright (c) 2015 LISNR, inc.
//  TSMessages: Copyright (c) 2014 Toursprung, Felix Krause <krausefx@gmail.com>
//

import UIKit

public class LNRNotification: NSObject {
    
    /**
     *  The title of this notification
     */
    public var title: String
    
    /**
     *  The body of this notification
     */
    public var body: String?
    
    /**
     *  The duration of the displayed notification. If it is 0.0 duration will default to the default notification display time
     */
    public var duration: TimeInterval
    
    /**
     *  An optional callback to be triggered whan a notification is tapped in addition to dismissing the notification.
     */
    public var onTap: LNRNotificationOperationCompletionBlock?
    
    /**
     *  An optional callback to be triggered whan a notification times out without being tapped.
     */
    public var onTimeout: LNRNotificationOperationCompletionBlock?
    
    /** Initializer for a LNRNotification. this library.
     *  @param title The title of the notification view
     *  @param body The body of the notification view (optional)
     *  @param duration The duration this notification should be displayed (optional)
     *  @param onTap The block that should be executed when the user taps on the notification
     *  @param onTimeout A block that should be executed when the notification times out. If the notification duration is set to endless (-1) this block will never be called.
     */
    public init(title: String, body: String?, duration: TimeInterval = LNRNotificationDuration.default.rawValue, onTap: LNRNotificationOperationCompletionBlock? = nil, onTimeout: LNRNotificationOperationCompletionBlock? = nil) {
        self.title = title
        self.body = body
        self.duration = duration
        self.onTap = onTap
        self.onTimeout = onTimeout
    }
}
