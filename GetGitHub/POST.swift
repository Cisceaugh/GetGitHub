//
//  POST.swift
//  GetGitHub
//
//  Created by Francisco Ragland Jr on 11/12/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

class POSTRepository: APIRequest {
    
    var name: String
    
    init(name: String) {
        self.name = name
        
        super.init()
        self.httpMethod = .POST
    }
    
    override func url() -> String {
        return "https://api.github.com/user/repos"
    }
    
    override func queryStringParameters() -> [String : String]? {
        
        do {
            
            let accessToken = try OAuthClient.shared.accessToken()
            return ["access_token" : accessToken]
            
        } catch _ {}
        
        return nil
    }
    
    override func httpBody() -> NSData? {
        
        do {
            return try NSJSONSerialization.dataWithJSONObject(["name" : self.name], options: NSJSONWritingOptions.PrettyPrinted)
        } catch _ {}
        
        return nil
    }
    
}