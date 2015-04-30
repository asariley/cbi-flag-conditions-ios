//
//  AppDelegate.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 12/25/14.
//  Copyright (c) 2014 Asa Riley. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    class var BASE_URL: String { return "http://cbiflagconditions.com" }
    class var UUID_KEY: String { return "uuid" }
    class var PUSH_TOKEN_KEY: String { return "pushToken" }
    
    var uuid: String!
    var pushToken: String?
    
    var conditionsViewController: ConditionsViewController? {
        if let w = self.window,
               r = w.rootViewController as? RootViewController,
               conditionsVC = r.modelController.conditionsOpt {
            return conditionsVC
        } else {
            return nil
        }
    }

    var notificationPrefsViewController: NotificationPrefsViewController? {
        if let w = self.window,
               r = w.rootViewController as? RootViewController,
               notificationPrefsVC = r.modelController.notificationPrefsOpt {
            return notificationPrefsVC
        } else {
            return nil
        }
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let newToken: String = deviceToken.hexadecimalString()
        if let existingPushToken = self.pushToken where existingPushToken == newToken {
            NSLog("Got same push token  as before. Doing nothing")
        } else {
            NSLog("Updating push token")
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newToken, forKey: AppDelegate.PUSH_TOKEN_KEY)
            defaults.synchronize()
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Failed to register for push notifications: \(error.localizedDescription)")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let existingUuid: String = defaults.stringForKey(AppDelegate.UUID_KEY) {
            self.uuid = existingUuid
        } else {
            self.uuid = NSUUID().UUIDString
            defaults.setObject(self.uuid!, forKey: AppDelegate.UUID_KEY)
            defaults.synchronize()
        }
        
        self.pushToken = defaults.stringForKey(AppDelegate.PUSH_TOKEN_KEY)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //SAVE FlagCondition and WindCondition
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let flagCondition: FlagCondition? = self.conditionsViewController?.flagCondition
        let notificationPref: NotificationPref? = self.notificationPrefsViewController?.prefs
        
        if let fc = flagCondition {
            defaults.setObject(flagConditionToDictionary(fc), forKey: ConditionsViewController.CONDITIONS_KEY)
        }
        if let np = notificationPref {
            defaults.setObject(notificationPrefToDictionary(np), forKey: NotificationPrefsViewController.NOTIFICATION_PREF_KEY)
        }
        
        defaults.synchronize()
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

