#LNRSimpleNotifications
__TSMessages__ is an amazingly powerful in-app notifications library but requires a lot of setup. __LNRSimpleNotifications__ is a simplified version for the developer who wants beautiful in-app notifications in minutes.

![Budweiser Made in America Screenshot](https://s3.amazonaws.com/lnr-simple-notifications/mia.png)
![LNRSimpleNotifications Demo Screenshot](https://s3.amazonaws.com/lnr-simple-notifications/demo-app-scale.png)
![Wakarusa Screenshot](https://s3.amazonaws.com/lnr-simple-notifications/waka-scale.png)

##How do I set it up?

We're glad you asked.

If your project is in Swift:

1. Install the Pod. Remember to add __use_frameworks!__ to your Podfile.
2. Add the AudioToolbox framework to your project. 
3. Add __import LNRSimpleNotifications__ in the classes you want to trigger or style your in-app notifications.
4. (Optional) Style your notifications in your AppDelegate's __application:didFinishLaunchingWithOptions:__ method or your notification manager's initializer.
5. There is no step Five.

If your project is in Objective-C:

1. Install the Pod. Remember to add __use_frameworks!__ to your Podfile.
2. Add the AudioToolbox framework to your project.
3. Set "Defines Modules" to __Yes__ in your build settings.
4. Import the LNRSimpleNotification module's Xcode-generated Swift header file in the classes you want to trigger and style your in-app notifications. The name of this header should be __#import \<LNRSimpleNotifications/LNRSimpleNotifications-Swift.h>__.
5. (Optional) Style your notifications in your AppDelegate's __application:didFinishLaunchingWithOptions:__ method or your notification manager's initializer.

## Demo Project

To run the demo project clone the repo, and run `pod install` from the Example directory first.

##How do I use it?
Configure up your notification styles once in your app. We usually use the method __application:didFinishLaunchingWithOptions:__ in __AppDelegate.m__. The init method for whatever class is triggering your in-app notifications is also a good choice.

__AppDelegate.m__

```swift
import LNRSimpleNotifications

###

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	// Override point for customization after application launch.
        
	LNRSimpleNotifications.sharedNotificationManager.notificationsPosition = LNRNotificationPosition.Top
	LNRSimpleNotifications.sharedNotificationManager.notificationsBackgroundColor = UIColor.whiteColor()
	LNRSimpleNotifications.sharedNotificationManager.notificationsTitleTextColor = UIColor.blackColor()
	LNRSimpleNotifications.sharedNotificationManager.notificationsBodyTextColor = UIColor.darkGrayColor()
	LNRSimpleNotifications.sharedNotificationManager.notificationsSeperatorColor = UIColor.grayColor()
        
	var alertSoundURL: NSURL? = NSBundle.mainBundle().URLForResource("click", withExtension: "wav")
	if let _ = alertSoundURL {
		var mySound: SystemSoundID = 0
		AudioServicesCreateSystemSoundID(alertSoundURL!, &mySound)
		LNRSimpleNotifications.sharedNotificationManager.notificationSound = mySound
	}
        
	return true
}
```

You can also configure an icon that will appear in your notification and set a custom font for the notification title and body.

If you don't set any theme options your notifications will default to black text on a white background with no notification sound or icon.


__The Class Triggering Notifications__

```swift
import LNRSimpleNotifications

###

func methodThatTriggersNotification:(title: String, body: String) {
	LNRSimpleNotifications.sharedNotificationManager.showNotification("Test Title", body: "Test Body", callback: { () -> Void in
		LNRSimpleNotifications.sharedNotificationManager.dismissActiveNotification({ () -> Void in
			println("Notification dismissed")
		})
	})
}
```

##Who's using LNRSimpleNotifications?
At the moment we know we've used it in:
 
- [Wakarusa](https://itunes.apple.com/app/id996589548)
- [Budweiser Made in America Festival] (https://itunes.apple.com/us/app/made-in-america-festival/id552043563?mt=8)

We're doing more music festivals this year, so you'll see our simple yet stylish notifications in our apps a few more times this Summer and Fall.

Have you used LNRSimpleNotifications in a project? Want your app featured here? Let us know at [dev@lisnr.com](dev@lisnr.com).

##Known Bugs

###Since 0.1.0

1. If you trigger notifications very rapidly they'll start appearing immediately instead of waiting for the one before to be dismissed before displaying. If this happens notifications will start appearing over notifications that were already on screen.

##Pull Requests?
Absolutely!

##About LISNR

LISNR is a startup leveraging high frequency, inaudible sounds waves to transmit data over audio. Using our technology we have activated synchronized light shows at concerts, triggered location-based notifications, rewarded music fans with behind-the-scenes content, delivered at-shelf product information, and solved pain points in sports stadiums for the Dallas Cowboys, Swedish House Mafia, Roc Nation, AT&T, Budweiser, and many more.

Want to know more about LISNR? Reach out to [dev@lisnr.com](dev@lisnr.com).

##License

__LNRSimpleNotifications__ is available under the MIT license. See LICENSE.txt for details.

##Credits

__LNRSimpleNotifications__ is based on __TSMessages__, developed by Felix Krause. If __LNRSimpleNotifications__ isn't quite what you're looking for we recommend you check [it](https://github.com/KrauseFx/TSMessages) out.