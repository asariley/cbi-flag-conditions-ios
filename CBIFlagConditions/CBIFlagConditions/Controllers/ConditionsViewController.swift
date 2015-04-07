//
//  ConditionsViewController.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 3/19/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import UIKit

class ConditionsViewController: UIViewController {

    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var skyImage: UIImageView!

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
    }


}