//
//  ViewController.swift
//  LNRSimpleNotifications Demo
//
//  LNRSimpleNotifications: Modifications of TSMessages Copyright (c) 2015 LISNR, inc.
//  TSMessages: Copyright (c) 2014 Toursprung, Felix Krause <krausefx@gmail.com>
//

import UIKit
import AudioToolbox
import LNRSimpleNotifications

class ViewController: UIViewController {
    
    let notificationManager1 = LNRNotificationManager()
    let notificationManager2 = LNRNotificationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationManager1.notificationsPosition = LNRNotificationPosition.Top
        notificationManager1.notificationsBackgroundColor = UIColor.whiteColor()
        notificationManager1.notificationsTitleTextColor = UIColor.blackColor()
        notificationManager1.notificationsBodyTextColor = UIColor.darkGrayColor()
        notificationManager1.notificationsSeperatorColor = UIColor.grayColor()
        notificationManager1.notificationsIcon = UIImage(named: "lisnr-cir-bw-notifications-icon")
        
        let alertSoundURL: NSURL? = NSBundle.mainBundle().URLForResource("click", withExtension: "wav")
        if let _ = alertSoundURL {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(alertSoundURL!, &mySound)
            notificationManager1.notificationSound = mySound
        }
        
        notificationManager2.notificationsPosition = LNRNotificationPosition.Bottom
        notificationManager2.notificationsBackgroundColor = UIColor.blackColor()
        notificationManager2.notificationsTitleTextColor = UIColor.whiteColor()
        notificationManager2.notificationsBodyTextColor = UIColor.whiteColor()
        notificationManager2.notificationsSeperatorColor = UIColor.grayColor()
        
        if let _ = alertSoundURL {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(alertSoundURL!, &mySound)
            notificationManager2.notificationSound = mySound
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IB Actions
    
    var incrementor = 0
    @IBAction func showNotificationButtonPressed(sender: AnyObject) {
        
        let notificationManager = (incrementor % 2 == 0) ? notificationManager1 : notificationManager2
        
        notificationManager.showNotification("Hipster Ipsum", body: "Schlitz you probably haven't heard of them raw denim brunch. Twee Kickstarter Truffaut cold-pressed trout banjo. Food truck iPhone normcore whatever selfies, actually ugh cliche PBR&B literally 8-bit. Farm-to-table retro VHS roof party, cold-pressed banh mi next level freegan .", callback: { () -> Void in
            
            notificationManager.dismissActiveNotification({ () -> Void in
                print("Notification dismissed")
            })
        })
        
        incrementor += 1
        
    }
    
}

