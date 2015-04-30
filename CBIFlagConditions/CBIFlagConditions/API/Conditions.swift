//
//  Conditions.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 3/19/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import Foundation

enum FlagColor: String {
    case RED = "RED"
    case YELLOW = "YELLOW"
    case GREEN = "GREEN"
    case CLOSED = "CLOSED"
}

enum WindDirection: String {
    case NORTH = "NORTH"
    case NORTHEAST = "NORTHEAST"
    case EAST = "EAST"
    case SOUTHEAST = "SOUTHEAST"
    case SOUTH = "SOUTH"
    case SOUTHWEST = "SOUTHWEST"
    case WEST = "WEST"
    case NORTHWEST = "NORTHWEST"
}

enum SkyCondition: String {
    case SUN = "SUN"
    case OVERCAST = "OVERCAST"
    case RAIN = "RAIN"
    case THUNDERSTORM = "THUNDERSTORM"
}

struct WindCondition{
    let speed: Double
    let direction: WindDirection
}

func windConditionToDictionary(w: WindCondition) -> Dictionary<String, AnyObject> {
    return [
        "speed": w.speed,
        "direction": w.direction.rawValue
    ]
}

func windConditionFromDictionary(dict: Dictionary<String, AnyObject>) -> WindCondition? {
    if let s = dict["speed"] as? Double,
           dStr = dict["direction"] as? String,
           d = WindDirection(rawValue: dStr) {
        return WindCondition(speed: s, direction: d)
    } else {
        NSLog("Couldn't make WindCondition from \(dict)")
        return nil
    }
}

struct FlagCondition {
    let color: FlagColor
    let updated: NSDate
    let wind: WindCondition
    let sunset: String
    let sky: SkyCondition
    let temperatureF: Double
}

func flagConditionToDictionary(fc: FlagCondition) -> Dictionary<String, AnyObject> {
    return [
        "color": fc.color.rawValue,
        "since": fc.updated,
        "wind": windConditionToDictionary(fc.wind),
        "sunset": fc.sunset,
        "sky": fc.sky.rawValue,
        "tempF": fc.temperatureF
    ]
}

func isoDateToNSDate(dateStr: String) -> NSDate? {
    let df: NSDateFormatter = NSDateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
    return df.dateFromString(dateStr)
}

func flagConditionFromDictionary(dict: Dictionary<String, AnyObject>) -> FlagCondition? {
    if let cStr = dict["color"] as? String,
           c = FlagColor(rawValue: cStr),
           sStr = dict["since"] as? String,
           s = isoDateToNSDate(sStr),
           wDict = dict["wind"] as? Dictionary<String, AnyObject>,
           w = windConditionFromDictionary(wDict),
           u = dict["sunset"] as? String,
           kStr = dict["sky"] as? String,
           k = SkyCondition(rawValue: kStr),
           t = dict["tempF"] as? Double {
        return FlagCondition(color: c, updated: s, wind: w, sunset: u, sky: k, temperatureF: t)
    } else {
        NSLog("Couldn't make FlagCondition from \(dict)")
        return nil
    }
}

func fetchCurrentConditions(onSuccess: FlagCondition? -> (), onFailure: NSError -> ()) {
    let requestUrl = NSURL(string: AppDelegate.BASE_URL + "/api/v1/conditions/current")
    let requestData: FlagCondition? = nil
    makeServiceCall(HttpVerb.GET, requestUrl!, requestData, onSuccess, onFailure, flagConditionToDictionary, flagConditionFromDictionary)
}

