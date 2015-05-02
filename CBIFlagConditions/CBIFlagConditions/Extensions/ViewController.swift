//
//  ViewController.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 4/25/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import Foundation
import UIKit


/*protocol ViewController: class {
    func appDelegate() -> PXAppDelegate
}*/

extension UIViewController {
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}