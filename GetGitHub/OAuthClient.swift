//
//  OAuthClient.swift
//  GetGitHub
//
//  Created by Francisco Ragland Jr on 11/11/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

typealias gitHubOAuthCompletion = (success: Bool) -> ()

let kAccessTokenKey = "kAccessTokenKey"
let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"

enum gitHubOAuthError: ErrorType{
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTemporaryCode(String)
    case ResponseFromGithub(String)
}

enum SaveOptions: Int {
    case UserDefaults
}

class OAuthClient {
    
    let kAccessTokenKey = "kAccessTokenKey"
    let kClientId = "9b6bfd768b1b45b675fa"
    let kClientSecret = "a525edcfb8ee9e5c07d3e2e9b4657c3592488442"

    static let shared = OAuthClient()
    
    func oAuthRequestWith(parameters: [String : String]) {
        var parametersString = String()
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"
        }
        
        // URL constructor.
        if let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(self.kClientId)\(parametersString)") {
            UIApplication.sharedApplication().openURL(requestURL)
        }
    }
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: gitHubOAuthCompletion) {
        
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(self.kClientId)&client_secret=\(self.kClientSecret)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString) {
                
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: sessionConfiguration)
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) -> Void in
                    
                    if let _ = error {
                        completion(success: false); return
                    }
                    
                    if let data = data {
                        if let tokenString = self.stringWith(data) {
                            
                            do {
                                let token = try self.accessTokenFromString(tokenString)!
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: self.saveAccessTokenToUserDefaults(token))
                                })
                                
                            } catch _ {
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: false)
                                })
                            }
                            
                        }
                    }
                }).resume()
            }
            
        } catch _ {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(success: false)
            })
        }
    }
    
    func accessToken() throws -> String {
        guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
            throw gitHubOAuthError.MissingAccessToken("You don't have access token saved.")
        }
        
        return accessToken

    }

    func requestGithubAccess() {
        let authURL = NSURL(string: "https://github.com/login/oauth/authorize?client_id=\(kClientId)&scope=user,repo")
        UIApplication.sharedApplication().openURL(authURL!)
    }
        
    func stringWith(data: NSData) -> String? {
        let byteBuffer: UnsafeBufferPointer<UInt8> = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        return String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
    }
    
    func accessTokenFromString(string: String) throws -> String? {
        
        do {
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, string.characters.count))
            if matches.count > 0 {
                for (_, value) in matches.enumerate() {
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                }
            }
        } catch _ {
            throw gitHubOAuthError.ExtractingTokenFromString("Could not extract token from string.")
        }
        
        return nil
    }
    
    func temporaryCodeFromCallback(url: NSURL) throws -> String {
        
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            throw gitHubOAuthError.ExtractingTemporaryCode("Error ExtractingTermporaryCode. See: temporaryCodeFromCallback:")
        }
        
        return temporaryCode
    }
    
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }


    
}