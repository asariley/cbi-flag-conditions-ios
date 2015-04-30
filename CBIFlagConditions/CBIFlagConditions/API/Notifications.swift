//
//  Notifications.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 4/7/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import Foundation

struct NotificationPref {
    let address: String
    let weekday: Bool
    let weekend: Bool
    let daytime: Bool
    let evening: Bool
    let red: Bool
    let yellow: Bool
    let green: Bool
    let closed: Bool
}

func notificationPrefToDictionary(np: NotificationPref) -> Dictionary<String, AnyObject> {
    return [
        "address": np.address,
        "weekday": np.weekday,
        "weekend": np.weekend,
        "daytime": np.daytime,
        "evening": np.evening,
        "redFlag"    : np.red,
        "yellowFlag" : np.yellow,
        "greenFlag"  : np.green,
        "closedFlag" : np.closed
    ]
}

func notificationPrefFromDictionary(dict: Dictionary<String, AnyObject>) -> NotificationPref? {
    if let a = dict["address"] as? String,
           wd = dict["weekday"] as? Bool,
           we = dict["weekend"] as? Bool,
           dt = dict["daytime"] as? Bool,
           ev = dict["evening"] as? Bool,
           rd = dict["redFlag"] as? Bool,
           yl = dict["yellowFlag"] as? Bool,
           gr = dict["greenFlag"] as? Bool,
           cl = dict["closedFlag"] as? Bool {
        return NotificationPref(address: a, weekday: wd, weekend: we, daytime: dt, evening: ev, red: rd, yellow: yl, green: gr, closed: cl)
    } else {
        NSLog("Couldn't make NotificationPref from \(dict)")
        return nil
    }
}

func fetchCurrentNotificationPrefs(deviceId: String, onSuccess: NotificationPref? -> (), onFailure: NSError -> ()) {
    let requestUrl = NSURL(string: AppDelegate.BASE_URL + "/api/v1/notifications/prefs/\(deviceId.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
    makeServiceCall(HttpVerb.GET, requestUrl!, nil, onSuccess, onFailure, notificationPrefToDictionary, notificationPrefFromDictionary)
}

func setNotificationPref(deviceId: String, notificationPref: NotificationPref, onSuccess: NotificationPref? -> (), onFailure: NSError -> ()) {
    let requestUrl = NSURL(string: AppDelegate.BASE_URL + "/api/v1/notifications/prefs/\(deviceId.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
    makeServiceCall(HttpVerb.POST, requestUrl!, notificationPref, onSuccess, onFailure, notificationPrefToDictionary, notificationPrefFromDictionary)
}
