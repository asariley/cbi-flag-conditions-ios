//
//  ConditionsViewController.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 3/19/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import UIKit

class ConditionsViewController: UIViewController {
    class var CONDITIONS_KEY: String { return "conditions" }

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var skyImage: UIImageView!
    
    private var conditionsRetrievedTime: NSDate? = nil
    var flagCondition: FlagCondition? = nil {
        didSet {
            if let fc = flagCondition {
                self.updateInterface(fc)
                self.conditionsRetrievedTime = NSDate()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.flagCondition == nil {
            let fcDict: Dictionary<String, AnyObject>? = NSUserDefaults.standardUserDefaults().dictionaryForKey(ConditionsViewController.CONDITIONS_KEY) as? Dictionary<String, AnyObject>
            
            self.flagCondition = flatMap(fcDict, flagConditionFromDictionary)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        func gotConditions(flagCondition: FlagCondition?) -> () {
            dispatch_async(dispatch_get_main_queue()) {
                self.spinner.stopAnimating()
                if let fc = flagCondition {
                    self.flagCondition = flagCondition
                }
            }
        }
        
        if (conditionsRetrievedTime.map {$0.compare(NSDate(timeIntervalSinceNow: -5*60)) == .OrderedAscending }) ?? true {
            fetchCurrentConditions(gotConditions) { (e: NSError) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    self.spinner.stopAnimating()
                    NSLog("error retrieving conditions: \(e)")
                }
            }
        }
    }
    
    private func updateInterface(fc: FlagCondition) {
        self.temperature.text = "\(Int(round(fc.temperatureF)))°F"
        self.sunset.text = fc.sunset
        self.windDirection.text = {
            switch(fc.wind.direction){
            case .NORTH: return "North"
            case .NORTHEAST: return "North East"
            case .EAST: return "East"
            case .SOUTHEAST: return "South East"
            case .SOUTH: return "South"
            case .SOUTHWEST: return "South West"
            case .WEST: return "West"
            case .NORTHWEST: return "North West"
            }
        }()
        self.windSpeed.text = "\(Int(round(fc.wind.speed))) MPH"
        self.lastUpdated.text = "Last updated \(NSDateFormatter.localizedStringFromDate(fc.updated, dateStyle: .MediumStyle, timeStyle: .MediumStyle))"

        self.flagImage.image = {
            switch(fc.color){
            case .GREEN: return UIImage(named: "GreenFlag")
            case .YELLOW: return UIImage(named: "YellowFlag")
            case .RED: return UIImage(named: "RedFlag")
            case .CLOSED: return UIImage(named: "ClosedFlag")
            }
        }()
        
        self.skyImage.image = {
            switch(fc.sky){
            case .SUN: return UIImage(named: "Sunny")
            case .OVERCAST: return UIImage(named: "Overcast")
            case .RAIN: return UIImage(named: "Rain")
            case .THUNDERSTORM: return UIImage(named: "Thunderstorm")
            }
        }()
    }
}
