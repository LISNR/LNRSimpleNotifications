//
//  LNRNotification.swift
//  LNRSimpleNotifications
//
//  Copyright © 2017 LISNR. All rights reserved.
//

import UIKit

public class LNRNotification: NSObject {
    public var title: String
    public var body: String?
    public var onTap: LNRNotificationOperationCompletionBlock?
    
    public init(title: String, body: String?, onTap: LNRNotificationOperationCompletionBlock?) {
        self.title = title
        self.body = body
        self.onTap = onTap
    }
}
