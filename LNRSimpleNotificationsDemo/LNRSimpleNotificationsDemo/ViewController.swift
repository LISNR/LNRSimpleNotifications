//
//  ViewController.swift
//  LNRSimpleNotifications Demo
//
//  LNRSimpleNotifications: Modifications of TSMessages Copyright (c) 2015 LISNR, inc.
//  TSMessages: Copyright (c) 2014 Toursprung, Felix Krause <krausefx@gmail.com>
//

import UIKit
//import LNRSimpleNotifications // Necessary import to use Pod

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IB Actions
    
    @IBAction func showNotificationButtonPressed(sender: AnyObject) {
        
        LNRSimpleNotifications.sharedNotificationManager.notificationsPosition = LNRNotificationPosition.Top
        LNRSimpleNotifications.sharedNotificationManager.notificationsBackgroundColor = UIColor.whiteColor()
        LNRSimpleNotifications.sharedNotificationManager.notificationsTitleTextColor = UIColor.blackColor()
        LNRSimpleNotifications.sharedNotificationManager.notificationsBodyTextColor = UIColor.darkGrayColor()
        LNRSimpleNotifications.sharedNotificationManager.notificationsSeperatorColor = UIColor.grayColor()
        LNRSimpleNotifications.sharedNotificationManager.notificationsIcon = UIImage(named: "lisnr-cir-bw-notifications-icon")
        
        LNRSimpleNotifications.sharedNotificationManager.showNotification("Hipster Ipsum", body: "Schlitz you probably haven't heard of them raw denim brunch. Twee Kickstarter Truffaut cold-pressed trout banjo. Food truck iPhone normcore whatever selfies, actually ugh cliche PBR&B literally 8-bit. Farm-to-table retro VHS roof party, cold-pressed banh mi next level freegan .", callback: { () -> Void in
            
            LNRSimpleNotifications.sharedNotificationManager.dismissActiveNotification({ () -> Void in
                print("Notification disimissed")
            })
        })
    }
    
    @IBAction func showSucceedNotificationButtonPressed(sender: AnyObject){
        
        LNRSimpleNotifications.sharedNotificationManager.showSucceedNotification("Action Succeed", body: "Congratulations!") { () -> Void in
            
            LNRSimpleNotifications.sharedNotificationManager.dismissActiveNotification({ () -> Void in
                print("Notification disimissed")
            })
        }
    }
    
    @IBAction func showFailedNotificationButtonPressed(sender: AnyObject){
        
        LNRSimpleNotifications.sharedNotificationManager.showFailedNotification("Action Failed", body: "WTF?!") { () -> Void in
            
            LNRSimpleNotifications.sharedNotificationManager.dismissActiveNotification({ () -> Void in
                print("Notification disimissed")
            })
        }
    }
    
    @IBAction func showInfoNotificationButtonPressed(sender: AnyObject){
        
        LNRSimpleNotifications.sharedNotificationManager.showInfoNotification("Info", body: "Just leave you a message!") { () -> Void in
            
            LNRSimpleNotifications.sharedNotificationManager.dismissActiveNotification({ () -> Void in
                print("Notification disimissed")
            })
        }
    }
    
}

