//
//  CreateAccountViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/15/15.
//  Copyright (c) 2015 Grapevine. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    var userToken: Token!
    var appUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedbackLabel.hidden = true
        self.activityIndicator.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: UIButton){
        
        func createAccountFailed(){
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.feedbackLabel.hidden = false
            //self.feedbackLabel.text = "Create Account Failed"
        }
        
        sender.enabled = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        let createAccountUrl = NSURL(string: apiBaseUrl + "/register")
        
        let newAccountInfo: [String: AnyObject] = [
            "username": String(self.usernameTextField.text!),
            "password": String(self.passwordTextField.text!)
        ]
        
        if NSJSONSerialization.isValidJSONObject(newAccountInfo){
            Alamofire.request(.POST, createAccountUrl!, parameters: newAccountInfo, encoding: .JSON)
                .responseJSON { response in
                    if response.1 != nil {
                        debugPrint(response)
                        if response.1?.statusCode == 200 {
                            print(response.2.value!)
                            self.userToken = Mapper<Token>().map(response.2.value)
                            //self.appUser.userID = self.userToken.userID
                            self.performSegueWithIdentifier("createAccountSegue", sender: self)
                        }
                        else {
                            createAccountFailed()
                            self.feedbackLabel.text = String(response.2.value)
                        }
                    }
                    else {
                        createAccountFailed()
                        print("call failed")
                    }
                    
            }
        }
        else {
            print("Json serialization failed. Critical Error")
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createAccountSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let eventsView = nav.topViewController as! EventListViewController
            eventsView.token = self.userToken
        }
        
    }


}
