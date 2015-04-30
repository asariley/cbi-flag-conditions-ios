//
//  ServiceCall.swift
//  CBIFlagConditions
//
//  Created by Asa Riley on 4/19/15.
//  Copyright (c) 2015 Asa Riley. All rights reserved.
//

import Foundation

enum HttpVerb: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

func makeServiceCall<RequestData, ResponseData>
    (verb: HttpVerb,
    requestUrl: NSURL,
    requestData: RequestData?,
    onSuccess: ResponseData? -> (),
    onError: NSError -> (),
    reqToDict: RequestData -> Dictionary<String, AnyObject>,
    respFromDict: Dictionary<String, AnyObject> -> ResponseData?) -> () {

    var errorOpt: NSError? = nil

    let req: NSMutableURLRequest = NSMutableURLRequest(URL: requestUrl)
    req.HTTPMethod = verb.rawValue
    if let dataObject = requestData {
        req.HTTPBody = NSJSONSerialization.dataWithJSONObject(reqToDict(dataObject), options: nil, error: &errorOpt)
    }
    if let error = errorOpt {
        onError(error)
        return
    }
    
    func onComplete(resp: NSURLResponse?, responseBody: NSData?, error: NSError?) -> () {
        if let err = error {
            onError(err)
            return
        }
        
        if let response = resp, httpResponse = response as? NSHTTPURLResponse {
            var jsonError: NSError? = nil
            let responseJSON: Dictionary<String, AnyObject>? = responseBody.flatMap({NSJSONSerialization.JSONObjectWithData($0, options: nil, error: &jsonError) as? Dictionary<String, AnyObject>})
            if let err = jsonError {
                onError(err)
                return
            }
            if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                let localizedDesc: String = (responseJSON?["errorMessage"] as? String) ?? "Received non-200 http status code"
                onError(NSError(domain: "HttpResponseCode", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: localizedDesc]))
                return
            }
            
            let responseObject: ResponseData? = responseJSON.flatMap(respFromDict)
            if (httpResponse.statusCode == 204 || responseObject != nil) {
                onSuccess(responseObject)
            } else {
                onError(NSError(domain: "HttpResponseCode", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Did not recieve content yet http status code was not 204"]))
            }
        } else {
            onError(NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Did not receive a http response"]))
        }

    }
    
    
    NSLog("url: \(req.URL)")
    if let body = req.HTTPBody {
        NSLog("body: \(NSString(data: body, encoding: NSUTF8StringEncoding))")
    }
    
    NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: onComplete)
}


