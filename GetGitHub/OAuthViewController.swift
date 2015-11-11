//
//  OAuthViewController.swift
//  GetGitHub
//
//  Created by Francisco Ragland Jr on 11/10/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    
    @IBAction func getGutHubButtonPressed(sender: UIButton) {
        OAuthClient.shared.requestGithubAccess()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
