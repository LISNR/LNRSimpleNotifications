//
//  LNRSimpleNotifications
//
//  LNRSimpleNotifications: Modifications of TSMessages Copyright (c) 2015 LISNR, inc.
//  TSMessages: Copyright (c) 2014 Toursprung, Felix Krause <krausefx@gmail.com>
//

import UIKit

let kLNRNotificationViewMinimumPadding: CGFloat = 15.0
let kStatusBarHeight: CGFloat = 20.0
let kBodyLabelTopPadding: CGFloat = 5.0

public class LNRNotificationView: UIView, UIGestureRecognizerDelegate {
    
    //MARK: Public
    
    /**
     *  Set to YES by the Notification manager while the notification view is onscreen
     */
    public var isDisplayed: Bool = false
    
    /**
     *  The LNRNotification this LNRNotificationView represents
     */
    public var notification: LNRNotification
    
    /** Inits the notification view. Do not call this from outside this library.
     *  
     *  @param notification The LNRNotification object this LRNNotificationView represents
     *  @param dismissingEnabled Should this notification be dismissed when the user taps/swipes it?
     */
    init(notification: LNRNotification, icon: UIImage?, notificationManager: LNRNotificationManager) {
        
        self.notification = notification
        self.notificationManager = notificationManager
        
        let notificationWidth: CGFloat = (UIApplication.shared.keyWindow?.bounds.width)!
        let padding: CGFloat = kLNRNotificationViewMinimumPadding
        
        super.init(frame: CGRect.zero)
        
        // Set background color
        self.backgroundColor = notificationManager.notificationsBackgroundColor
        
        // Set up Title label
        self.titleLabel.text = notification.title
        self.titleLabel.textColor = notificationManager.notificationsTitleTextColor
        self.titleLabel.font = notificationManager.notificationsTitleFont
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.addSubview(self.titleLabel)
        
        if let bodyText = notification.body {
            if bodyText.characters.count > 0 {
                self.bodyLabel.text = bodyText
                self.bodyLabel.textColor = notificationManager.notificationsBodyTextColor
                self.bodyLabel.font = notificationManager.notificationsBodyFont
                self.bodyLabel.backgroundColor = UIColor.clear
                self.bodyLabel.numberOfLines = 0
                self.bodyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.addSubview(self.bodyLabel)
            }
        }
        
        if let icon = icon {
            self.iconImageView.image = icon
            self.iconImageView.frame = CGRect(x: padding, y: padding, width: icon.size.width, height: icon.size.height)
            self.addSubview(self.iconImageView)
        }
        
        self.seperator.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: notificationWidth, height: (1.0)) //Set seperator position at the top of the notification view. If notification position is Top we'll update it when we layout subviews.
        self.seperator.backgroundColor = notificationManager.notificationsSeperatorColor
        self.seperator.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.addSubview(self.seperator)
        
        let notificationHeight:CGFloat = self.notificationViewHeightAfterLayoutOutSubviews(padding, notificationWidth: notificationWidth)
        var topPosition:CGFloat = -notificationHeight;
        
        if notificationManager.notificationsPosition == LNRNotificationPosition.bottom {
            topPosition = UIScreen.main.bounds.size.height
        }
        
        self.frame = CGRect(x: CGFloat(0.0), y: topPosition, width: notificationWidth, height: notificationHeight)
        
        if notificationManager.notificationsPosition == LNRNotificationPosition.top {
            self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        } else {
            self.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        }
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LNRNotificationView.handleTap(tapGestureRecognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /**
     * Required initializer 'init(coder:)' must be implemented by subclasses of UIView
     */
    required public init?(coder decoder: NSCoder) {
        assertionFailure("Cannot initialize LNRNotificationView with init:decoder")
        self.notification = LNRNotification(title: "", body: nil, onTap: nil, onTimeout: nil)
        super.init(coder: decoder)
    }
    
    /**
     *  Dismisses this notification if this notification is currently displayed.
     *  @param completion A block called after the completion of the dismiss animation. This block is only called if the notification was displayed on screen at the time dismissWithCompletion: was called.
     *  @return true if notification was displayed at the time dismissWithCompletion: was called, false if notification was not displayed.
     */
    public func dismissWithCompletion(_ completion: LNRNotificationOperationCompletionBlock?) -> Bool {
        return notificationManager.dismissNotificationView(notificationView: self, dismissAnimationCompletion: completion)
    }
    
    //MARK: Layout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let _ = self.notificationViewHeightAfterLayoutOutSubviews(kLNRNotificationViewMinimumPadding, notificationWidth: (UIApplication.shared.keyWindow?.bounds.width)!)
    }
    
    func notificationViewHeightAfterLayoutOutSubviews(_ padding: CGFloat, notificationWidth: CGFloat) -> CGFloat {
        
        var height: CGFloat = 0.0
        
        var textLabelsXPosition: CGFloat = 2.0 * padding
        let statusBarVisible = !UIApplication.shared.isStatusBarHidden
        let topPadding = self.notificationManager.notificationsPosition == LNRNotificationPosition.top && statusBarVisible ? kStatusBarHeight + padding : padding
        
        if let image = self.iconImageView.image {
            textLabelsXPosition += image.size.width
        }
        
        self.titleLabel.frame = CGRect(x: textLabelsXPosition, y: topPadding, width: notificationWidth - textLabelsXPosition - padding, height: CGFloat(0.0))
        self.titleLabel.sizeToFit()
        
        if self.notification.body != nil && (self.notification.body!).characters.count > 0 {
            self.bodyLabel.frame = CGRect(x: textLabelsXPosition, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kBodyLabelTopPadding, width: notificationWidth - padding - textLabelsXPosition, height: 0.0)
            self.bodyLabel.sizeToFit()
            height = self.bodyLabel.frame.origin.y + self.bodyLabel.frame.size.height
        } else {
            //Only title label set
            height = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height
        }
        
        height += padding
        
        let yPosition = self.notificationManager.notificationsPosition == LNRNotificationPosition.top && statusBarVisible ?
            round((kStatusBarHeight+height) / 2.0) : round((height) / 2.0)
        self.iconImageView.center = CGPoint(x: self.iconImageView.center.x, y: yPosition)
        
        if self.notificationManager.notificationsPosition == LNRNotificationPosition.top {
            var seperatorFrame: CGRect = self.seperator.frame
            seperatorFrame.origin.y = height
            self.seperator.frame = seperatorFrame
        }
        
        height += self.seperator.frame.size.height
        
        self.frame = CGRect(x: CGFloat(0.0), y: self.frame.origin.y, width: self.frame.size.width, height: height)
        
        return height
    }
    
    //MARK: Private
    
    private let titleLabel: UILabel = UILabel()
    private let bodyLabel: UILabel = UILabel()
    private let iconImageView: UIImageView = UIImageView()
    private let seperator: UIView = UIView()
    private var notificationManager: LNRNotificationManager!
    
    //MARK: Tap Recognition
    
    func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == UIGestureRecognizerState.ended {
            let _ = dismissWithCompletion(nil)
            if self.notification.onTap != nil {
                self.notification.onTap!()
            }
        }
    }
    
}
