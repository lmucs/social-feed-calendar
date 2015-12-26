//
//  SettingsViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 12/21/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrapevineButton(logoutButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(sender: UIButton!){
        sender.enabled = false
        // would also need to invalid token eventually
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
