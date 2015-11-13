//
//  GETUser.swift
//  GetGitHub
//
//  Created by Francisco Ragland Jr on 11/12/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import Foundation


class GETUser: APIRequest {
    
    override func url() -> String {
        return "https://api.github.com/user"
    }
    
    override func queryStringParameters() -> [String : String]? {
        
        do {
            
            let accessToken = try OAuthClient.shared.accessToken()
            return ["access_token" : accessToken]
            
        } catch _ {}
        
        return nil
    }
    
}