//
//  Github Service.swift
//  GetGitHub
//
//  Created by Francisco Ragland Jr on 11/11/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import Foundation

class GithubService {
    
    class func searchWithTerm(term: String, completion: (success: Bool, json: [AnyObject]) -> ()){
        
        // https://api.github.com/search
    }
    
    class func GETRepositories(completion: (success: Bool, json: [AnyObject]) -> ()) {
        
        do {
            
            let token = try OAuthClient.shared.accessToken()
            guard let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)") else { return }
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                        print(json)
                    } catch _ {}
                }
            }).resume()
        }catch _ {}
    
    }
}