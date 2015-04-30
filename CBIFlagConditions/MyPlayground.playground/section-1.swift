// Playground - noun: a place where people can play

import UIKit

let str = "Hello, playground"


enum HttpVerb: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

let v: HttpVerb = .GET
v.rawValue


let d: Dictionary<String, AnyObject> = ["1": 1, "2": true, "4": "GET", "5": NSDate()]

let a: Int? = d["1"] as? Int
let b: Bool? = d["2"] as? Bool
let c: String? = d["3"] as? String
let e: HttpVerb? = d["4"] as? HttpVerb
let f: NSDate? = d["5"] as? NSDate

let df: NSDateFormatter = NSDateFormatter()
df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
let r: NSDate? = df.dateFromString("2015-04-25T20:59:23-04:00")

Int(round(1.4))
Int(round(1.5))
Int(round(1.6))
Int(round(2.5))


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


import CoreBluetooth

let u: NSUUID = NSUUID()

let cb: CBUUID = CBUUID(NSUUID:u)

let nsd: NSData = cb.data

let hex: String = nsd.hexadecimalString()

println(hex)



