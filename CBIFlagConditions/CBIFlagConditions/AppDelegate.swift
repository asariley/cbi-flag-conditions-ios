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
    class var HAS_VISITED: String {return "hasVisited"}
    
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
    
    var firstTimeVisitor: Bool {
        if let keyExists: Bool = NSUserDefaults.standardUserDefaults().objectForKey(AppDelegate.HAS_VISITED) as? Bool {
            return false
        } else {
            NSLog("First time launch!")
            return true
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
        
        defaults.setObject(true, forKey: AppDelegate.HAS_VISITED)
        
        defaults.synchronize()
    }



}

