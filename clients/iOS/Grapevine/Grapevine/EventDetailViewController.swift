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
    
    @IBOutlet weak var eventLinkButton : UIButton!
    @IBOutlet weak var eventMonthLabel: UILabel!
    @IBOutlet weak var eventDayLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventPostView: UITextView!
    @IBOutlet weak var eventAuthorLabel: UILabel!
    @IBOutlet weak var eventTagsLabel: UILabel!
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image:textLogoSmall)
        imageView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imageView
        
        if self.event != nil {
            let date = event.startTime.dateCV
            self.eventPostView.layer.borderWidth = 2.0
            self.eventPostView.layer.borderColor = UIColor.purpleColor().CGColor
            self.eventPostView.layer.cornerRadius = 8
            self.eventTitleLabel.text = self.event.title
            self.eventTitleLabel.numberOfLines = 0
            self.eventMonthLabel.text = monthIntToShortMonthString(date.month)
            self.eventDayLabel.text = String(date.day)
            self.eventTimeLabel.text = buildEventTimeRange(event)
            self.eventLinkButton.setTitle("View Original Post", forState: .Normal)
            self.eventLinkButton.titleLabel?.numberOfLines = 0
            self.eventPostView.text = self.event.post + "\n \n" + self.event.locationToString()
            self.eventAuthorLabel.text = self.event.author
            if self.event.tags.count > 0 {
                var tagsStr: String = ""
                for tag in self.event.tags {
                    tagsStr = "#" + tag + ", " + tagsStr
                }
                // removes last comma, space
                tagsStr = String(tagsStr.characters.dropLast())
                tagsStr = String(tagsStr.characters.dropLast())
                self.eventTagsLabel.text = tagsStr
            }
            else {
                self.eventTagsLabel.hidden = true
            }
            
            if self.event.location != nil {
                print(self.event.location)
            }
            else {
                print("no location")
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openLink(sender: AnyObject) {
        var link = event.url!
        let urlStartHttp: String = "http://"
        let urlStartHttps: String = "https://"
        if !(link.hasPrefix(urlStartHttp) || link.hasPrefix(urlStartHttps)) {
            link = urlStartHttp + link
        }
        UIApplication.sharedApplication().openURL(NSURL(string: link)!)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "backToListSegue" {
            
        }
        if segue.identifier == "backToCalendar" {
            
        }
        
    }


}
