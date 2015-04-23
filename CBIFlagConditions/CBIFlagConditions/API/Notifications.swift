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

private func dictToWindCondition(reply: [String: Any]) -> NotificationPref? {
    return nil
}

func fetchCurrentNotificationPrefs(onSuccess: NotificationPref? -> (), onFailure: NSError -> ()) {
    
}

func setNotificationPref(onSuccess: () -> (), onFailure: NSError -> ()) {
    
}
