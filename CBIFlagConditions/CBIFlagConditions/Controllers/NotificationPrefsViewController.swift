//
//  NotificationsViewController.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 4/6/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import UIKit

class NotificationPrefsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    class var NOTIFICATION_PREF_KEY: String { return "notificationPref" }
    
    weak var master: UISwitch?
    weak var weekend: UISwitch?
    weak var weekday: UISwitch?
    weak var daytime: UISwitch?
    weak var evening: UISwitch?
    weak var green: UISwitch?
    weak var yellow: UISwitch?
    weak var red: UISwitch?
    weak var closed: UISwitch?
    
    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var prefs: NotificationPref? = nil {
        didSet {
            if let np = prefs {
                self.updateInterface(np)
            } else {
                self.submit?.enabled = true
            }
        }
    }
    
    /** 
      * Method to handle new pref data. 
      * Up here in outer scope so it can be used by both viewDidLoad: and submitPressed:
      */
    func gotPref(pref: NotificationPref?) -> () {
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.stopAnimating()
            if let p = pref {
                self.prefs = p
                self.submit.enabled = false
            } else {
                self.submit.enabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.clearColor()

        //Register for notifications
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        //Load current notification prefs from storage
        if self.prefs == nil {
            let prefDict: Dictionary<String, AnyObject>? = NSUserDefaults.standardUserDefaults().dictionaryForKey(NotificationPrefsViewController.NOTIFICATION_PREF_KEY) as? Dictionary<String, AnyObject>
            
            self.prefs = flatMap(prefDict, notificationPrefFromDictionary)
        }
    
        fetchCurrentNotificationPrefs(self.appDelegate().uuid, gotPref) { (e: NSError) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.spinner.stopAnimating()
                NSLog("error retrieving notification prefs: \(e)")
            }
        }
    }
    
    private func updateInterface(np: NotificationPref) {
        self.master?.on = np.weekday || np.weekend || np.daytime || np.evening || np.red || np.yellow || np.green || np.closed
        self.weekday?.on = np.weekday
        self.weekend?.on = np.weekend
        self.daytime?.on = np.daytime
        self.evening?.on = np.evening
        self.green?.on = np.green
        self.yellow?.on = np.yellow
        self.red?.on = np.red
        self.closed?.on = np.closed
        //Make sure button doesn't re enable if it was disabled before
    }

    @IBAction func submitPressed(sender: AnyObject) {
        //check current notification settings to make sure we are allowed.
        if (UIApplication.sharedApplication().currentUserNotificationSettings().types & UIUserNotificationType.Alert) == nil {
            //PRESENT ALERT PROMPTING TO ENABLE NOTIFICATIONS
            let alert = UIAlertController(title: "Notifications Disabled", message: "To enable notifications in the settings app", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: {
                (uaa: UIAlertAction!) -> () in
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //make sure we have a push token
        if let pushToken = self.appDelegate().pushToken,
               weekend = self.weekend?.on,
               weekday = self.weekday?.on,
               daytime = self.daytime?.on,
               evening = self.evening?.on,
               green = self.green?.on,
               yellow = self.yellow?.on,
               red = self.red?.on,
               closed = self.closed?.on {
            let n = NotificationPref(address:pushToken, weekday: weekday, weekend: weekend, daytime: daytime, evening: evening, red: red, yellow: yellow, green: green, closed: closed)
            
            self.spinner.startAnimating()
            submit.enabled = false
            setNotificationPref(self.appDelegate().uuid, n, gotPref) { (e: NSError) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    self.spinner.stopAnimating()
                    self.submit.enabled = true
                    NSLog("error retrieving conditions: \(e)")
                }
            }
        } else {
            NSLog("Unable to make NotificationPref. (Does a push token exist?)")
            if self.appDelegate().pushToken == nil {
                UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
            
                let alert = UIAlertController(title: "Are Push Notifications Enabled?", message: "Unable to register for push notifications. Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }

        
    }

    @IBAction func switchFlipped(sender: AnyObject) {
        let s: UISwitch = sender as! UISwitch
        if s === master! {
            weekend?.setOn(s.on, animated: true)
            weekday?.setOn(s.on, animated: true)
            daytime?.setOn(s.on, animated: true)
            evening?.setOn(s.on, animated: true)
            green?.setOn(s.on, animated: true)
            yellow?.setOn(s.on, animated: true)
            red?.setOn(s.on, animated: true)
            closed?.setOn(s.on, animated: true)
        }
        submit.enabled = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return 4
        case 2: return 4
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Master"
        case 1: return "Time Conditions"
        case 2: return "Color Conditions"
        default: return nil
        }
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return "Notification is sent when flag changes to selected color"
        } else { return nil }
    }
    
    private func timeCondtionCells(row: Int, prototypeCell: RowWithSwitch) -> UITableViewCell {
        switch(row) {
        case 0:
            weekday = prototypeCell.enabled
            prototypeCell.label.text = "Weekdays"
        case 1:
            weekend = prototypeCell.enabled
            prototypeCell.label.text = "Weekends"
        case 2:
            daytime = prototypeCell.enabled
            prototypeCell.label.text = "Daytime (before 4:30PM)"
        case 3:
            evening = prototypeCell.enabled
            prototypeCell.label.text = "Evening (after 4:30PM)"
        default: ()
        }
        return prototypeCell
    }
    
    private func colorConditionCells(row: Int, prototypeCell: RowWithSwitch) -> UITableViewCell {
        switch(row) {
        case 0:
            green = prototypeCell.enabled
            prototypeCell.label.text = "Green"
        case 1:
            yellow = prototypeCell.enabled
            prototypeCell.label.text = "Yellow"
        case 2:
            red = prototypeCell.enabled
            prototypeCell.label.text = "Red"
        case 3:
            closed = prototypeCell.enabled
            prototypeCell.label.text = "Closed"
        default: ()
        }
        return prototypeCell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(RowWithSwitch.identifier) as! RowWithSwitch
        switch(indexPath.section) {
        case 0: //return master row
            master = cell.enabled
            cell.label.text = "Allow Notifications"
            //cell.enabled.addTarget(self, action: Selector("switchFlipped:"), forControlEvents: .ValueChanged)
            return cell
        case 1: return timeCondtionCells(indexPath.row, prototypeCell: cell)
        case 2: return colorConditionCells(indexPath.row, prototypeCell: cell)
        default: return cell //THIS SHOULD NEVER HAPPEN
        }
    }
}

class RowWithSwitch: UITableViewCell {
    @IBOutlet weak var enabled: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    static var identifier: String { return "notificationRowWithSwitch" }
}
