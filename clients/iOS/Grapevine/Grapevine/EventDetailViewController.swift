//
//  EventDetailViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 11/17/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var event: Event!
    
    @IBOutlet weak var eventLinkLabel : UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        if self.event != nil {
            self.eventTitleLabel.text = self.event.title
            self.eventTimeLabel.text = String(self.event.startTimeNS)
            self.eventLinkLabel.text = self.event.url
            self.eventLinkLabel.numberOfLines = 0

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
