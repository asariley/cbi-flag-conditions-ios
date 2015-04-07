//
//  Conditions.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 3/19/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import Foundation

enum FlagColor {
    case RED, YELLOW, GREEN, CLOSED
}

enum WindDirection {
    case NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST
}

enum SkyCondition {
    case SUN, OVERCAST, RAIN, THUNDERSTORM
}

struct WindCondition {
    let speed: Double
    let direction: WindDirection
}

struct FlagCondition {
    let color: FlagColor
    let updated: NSDate
    let wind: WindCondition
    let sunset: NSDate
    let sky: SkyCondition
    let temperatureF: Double
}

//FIXME discover accepted way to parse json in swift
private func dictToWindCondition(reply: [String: Any]) -> WindCondition? {
    return nil
}

private func dictToFlagCondition(reply: [String: Any]) -> FlagCondition? {
    return nil
}

func fetchCurrentConditions(onSuccess: FlagCondition -> (), onFailure: NSError -> ()) {
    
}
