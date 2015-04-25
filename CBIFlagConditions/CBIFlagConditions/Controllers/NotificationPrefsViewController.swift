//
//  NotificationsViewController.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 4/6/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import UIKit

class NotificationPrefsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Registerforpush
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func submitPressed(sender: AnyObject) {

        // start spinner
        // collect data
        // make api call
        // if successful: end spinner disable submit button
        // if failure: end spinner enable submit button
        NSLog("Submit pressed")
        submit.enabled = false
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
        submit.enabled = true // only set this to true if we get a device Id
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
