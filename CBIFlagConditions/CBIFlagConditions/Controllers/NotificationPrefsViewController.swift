//
//  NotificationsViewController.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 4/6/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import UIKit

class NotificationPrefsViewController: UIViewController {

    @IBOutlet weak var master: UISwitch!
    @IBOutlet weak var weekend: UISwitch!
    @IBOutlet weak var weekday: UISwitch!
    @IBOutlet weak var daytime: UISwitch!
    @IBOutlet weak var evening: UISwitch!
    @IBOutlet weak var green: UISwitch!
    @IBOutlet weak var yellow: UISwitch!
    @IBOutlet weak var red: UISwitch!
    @IBOutlet weak var closed: UISwitch!
    @IBOutlet weak var submit: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // register for push notifications
    }

    @IBAction func submitPressed(sender: AnyObject) {

        // start spinner
        // collect data
        // make api call
        // if successful: end spinner disable submit button
        // if failure: end spinner enable submit button
        submit.enabled = false
    }

    @IBAction func switchFlipped(sender: AnyObject) {
        let s: UISwitch = sender as! UISwitch
        if s === master {
            weekend.setOn(s.on, animated: true)
            weekday.setOn(s.on, animated: true)
            daytime.setOn(s.on, animated: true)
            evening.setOn(s.on, animated: true)
            green.setOn(s.on, animated: true)
            yellow.setOn(s.on, animated: true)
            red.setOn(s.on, animated: true)
            closed.setOn(s.on, animated: true)
        }
        submit.enabled = true // only set this to true if we get a 
    }

}