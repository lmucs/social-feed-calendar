//
//  LoginViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/15/15.
//  Copyright (c) 2015 Grapevine. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CVCalendar

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginFailedLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userToken: Token!
    var appUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Do any additional setup after loading the view.
        self.activityIndicator.hidden = true
        self.loginFailedLabel.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //link back from CreateAccountVC
    @IBAction func backToLoginViewController(segue:UIStoryboardSegue) {
        
    }
    

    @IBAction func loginPressed(sender: UIButton){
        
        func loginFailed(){
            self.activityIndicator.hidden = true
            self.loginFailedLabel.hidden = false
            setErrorColor(self.usernameTextField)
            setErrorColor(self.passwordTextField)
            sender.enabled =  true
        }
        
        sender.enabled = false
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
    
        let loginUrl = NSURL(string: apiBaseUrl + "/login")
        
        let loginCredentials: [String: AnyObject] = [
            "username": String(self.usernameTextField.text!),
            "password": String(self.passwordTextField.text!)
        ]
        
        self.appUser = Mapper<User>().map(loginCredentials)
        
        if NSJSONSerialization.isValidJSONObject(loginCredentials){
            Alamofire.request(.POST, loginUrl!, parameters: loginCredentials, encoding: .JSON)
                .responseJSON { response in
                    if response.1 != nil {
                        print("debug response printing")
                        debugPrint(response)
                        if response.1?.statusCode == 200 {
                            print(response.2.value!)
                            print("here")
                            
                            let responseToken = Mapper<Token>().map(response.2.value)
                            print("Response token is \(responseToken!.token) \n")
                            self.userToken = responseToken
                            print("UserID is \(self.userToken.userID)")
                            self.appUser.userID = self.userToken.userID
                            //print(self.appUser.userID)
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                        }
                        else {
                            print("didn't get a 200")
                            self.loginFailedLabel.text = "Invalid Credentials"
                            loginFailed()
                            self.appUser = nil
                            // handle errors based on response code
                            
                        }
                    }
                    else {
                        print("no response")
                        self.loginFailedLabel.text = "Connection Failed"
                        loginFailed()
                        self.appUser = nil
                        
                    }
                    
            }
        }
        else {
            //JSON invalid, throw exception
        }

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "loginSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let eventsView = nav.topViewController as! EventListViewController
            print("Token Object again is \(self.userToken.token)")
            
            let getEventsUrl = NSURL(string: apiBaseUrl + "/api/v1/users/" + String(self.userToken.userID!) + "/events")
            let requestHeader: [String: String] = [
                "Content-Type": "application/json",
                "x-access-token": String(self.userToken.token!)
            ]
            print("calling for events now swag")
            Alamofire.request(.GET, getEventsUrl!, encoding: .JSON, headers: requestHeader)
                .responseJSON { response in
                    if response.1 != nil {
                        
                        if response.1?.statusCode == 200 {
                            let results = response.2.value! as! NSArray
                            //debugPrint(results)
                            for item in results {
                                debugPrint(item)
                                let responseEvent = Mapper<Event>().map(item)
                                if responseEvent!.dateNS != nil {
                                    responseEvent!.date = Date(date: responseEvent!.dateNS)
                                }
                                if responseEvent!.startTimeNS != nil {
                                    responseEvent!.date = Date(date: responseEvent!.startTimeNS)
                                }
                                if responseEvent!.endTimeNS != nil {
                                    responseEvent!.date = Date(date: responseEvent!.endTimeNS)
                                }
                                eventsView.events.append(responseEvent!)
                            }
                            if eventsView.events.count > 1 {
                                eventsView.events = eventsView.events.sort({$0.startTimeNS.compare($1.startTimeNS) == NSComparisonResult.OrderedAscending})
                            }
                            eventsView.tableView.reloadData()
                        }
                    }
            }

            
            
            
            
            
        }
    }
   
    
}