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


