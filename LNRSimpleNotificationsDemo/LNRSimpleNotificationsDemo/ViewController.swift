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
        
        notificationManager1.notificationsPosition = LNRNotificationPosition.top
        notificationManager1.notificationsBackgroundColor = UIColor.white
        notificationManager1.notificationsTitleTextColor = UIColor.black
        notificationManager1.notificationsBodyTextColor = UIColor.darkGray
        notificationManager1.notificationsSeperatorColor = UIColor.gray
        notificationManager1.notificationsDefaultDuration = 10
        notificationManager1.notificationsIcon = UIImage(named: "lisnr-cir-bw-notifications-icon")

        let alertSoundURL: URL? = Bundle.main.url(forResource: "click", withExtension: "wav")
        if let _ = alertSoundURL {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(alertSoundURL! as CFURL, &mySound)
            notificationManager1.notificationSound = mySound
        }
        
        notificationManager2.notificationsPosition = LNRNotificationPosition.bottom
        notificationManager2.notificationsBackgroundColor = UIColor.black
        notificationManager2.notificationsTitleTextColor = UIColor.white
        notificationManager2.notificationsBodyTextColor = UIColor.white
        notificationManager2.notificationsSeperatorColor = UIColor.gray
        
        if let _ = alertSoundURL {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(alertSoundURL! as CFURL, &mySound)
            notificationManager2.notificationSound = mySound
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IB Actions
    
    var incrementor = 0
    @IBAction func showNotificationButtonPressed(_ sender: AnyObject) {
        
        let notificationManager = (incrementor % 2 == 0) ? notificationManager1 : notificationManager2
        
        let imageViewSetup : LNRNotificationImageViewSetupBlock = { imageView in
            imageView.backgroundColor = UIColor.red
        }
        
        let imageAsyncLoader : LNRNotificationAsyncImageBlock = { completionHandler in
            let url = URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                guard let data = data  else { return }
                let downloadedData = UIImage(data: data)
                completionHandler(downloadedData)
            }).resume()
        }
        
        
        notificationManager.showNotification(
            title: "Hipster Ipsum",
            body: "Schlitz you probably haven't heard of them raw denim brunch. Twee Kickstarter Truffaut cold-pressed trout banjo. Food truck iPhone normcore whatever selfies, actually ugh cliche PBR&B literally 8-bit. Farm-to-table retro VHS roof party, cold-pressed banh mi next level freegan .",
            onTap: { () -> Void in
            
            let _ = notificationManager.dismissActiveNotification(completion: { () -> Void in
                print("Notification dismissed")
            })
            
            },
            imageAsyncLoader:  imageAsyncLoader,
            imageViewSetup:  imageViewSetup
        )
        
        incrementor += 1
        
    }
    
}

