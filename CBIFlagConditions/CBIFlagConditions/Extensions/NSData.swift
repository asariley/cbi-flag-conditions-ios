//
//  NSData.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 4/26/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import Foundation


extension NSData {

    /// Create hexadecimal string representation of NSData object.
    ///
    /// :returns: String representation of this NSData object.

    func hexadecimalString() -> String {
        var string = NSMutableString(capacity: length * 2)
        var byte: UInt8 = 0

        for i in 0 ..< length {
            getBytes(&byte, range: NSMakeRange(i, 1))
            string.appendFormat("%02x", byte)
        }

        return String(string)
    }
}