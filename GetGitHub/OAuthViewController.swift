//
//  OAuthViewController.swift
//  GetGitHub
//
//  Created by Francisco Ragland Jr on 11/10/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

typealias OAuthViewControllerCompletionHandler = () -> ()

class OAuthViewController: UIViewController {
    
    var oauthCompletionHandler: OAuthViewControllerCompletionHandler?
    
    @IBOutlet weak var loginButton: UIButton!

    
    class func identifier() -> String {
        return "OAuthViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    func processOauthRequest() {
        if let oauthCompletionHandler = self.oauthCompletionHandler {
            oauthCompletionHandler()
        }
    }
    
    @IBAction func loginButtonSelected(sender: UIButton) {
        NSOperationQueue().addOperationWithBlock { () -> Void in
//            usleep(1000000)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            OAuthClient.shared.oAuthRequestWith(["scope" : "email,user,repo"])
            })
        }
    }
    
}
