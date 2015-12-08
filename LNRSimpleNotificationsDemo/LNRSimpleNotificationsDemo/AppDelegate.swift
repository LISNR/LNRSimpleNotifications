//
//  AppDelegate.swift
//  LNRSimpleNotifications Demo
//
//  LNRSimpleNotifications: Modifications of TSMessages Copyright (c) 2015 LISNR, inc.
//  TSMessages: Copyright (c) 2014 Toursprung, Felix Krause <krausefx@gmail.com>
//

import UIKit
import AudioToolbox
//import LNRSimpleNotifications // Necessary import to use Pod

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        LNRSimpleNotifications.sharedNotificationManager.notificationsPosition = LNRNotificationPosition.Top
//        LNRSimpleNotifications.sharedNotificationManager.notificationsBackgroundColor = UIColor.whiteColor()
//        LNRSimpleNotifications.sharedNotificationManager.notificationsTitleTextColor = UIColor.blackColor()
//        LNRSimpleNotifications.sharedNotificationManager.notificationsBodyTextColor = UIColor.darkGrayColor()
//        LNRSimpleNotifications.sharedNotificationManager.notificationsSeperatorColor = UIColor.grayColor()
//        LNRSimpleNotifications.sharedNotificationManager.notificationsIcon = UIImage(named: "lisnr-cir-bw-notifications-icon")
        
        let alertSoundURL: NSURL? = NSBundle.mainBundle().URLForResource("click", withExtension: "wav")
        if let _ = alertSoundURL {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(alertSoundURL!, &mySound)
            LNRSimpleNotifications.sharedNotificationManager.notificationSound = mySound
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

