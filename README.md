<img src="https://github.com/lmucs/grapevine/blob/master/images/grapevine.PNG?raw=true" width=90 height=90>
# Grapevine


Grapevine is a application that automatically populates a user's calendar with events from Twitter and Facebook. A user can add a list of facebook users and twitter users to follow. Grapevine will listen to these feeds and extract events from feeds.

## Extracting Events
Consider the case where Grapevine is listening to @LoyolaMarymount. Grapevine will request tweets from Twitter from @LoyolaMarymount.

TODO- Insert list view or pictures tweets here

Grapevine will then go over the text and see if any of the posts have any events. If it finds any events, it sends stores them and pushes the events to the user. These events are put on the user's Grapevine calendar.

TODO - Insert calendar views of the same event for Android, iOS, and web.

Events have information such as start time, who posted the event, and a link to the original post.

TODO - server info, App Store / Google Play info

TODO - getting your own installation, npm install ....

## About

It was created as part of the CMSI 401 class at Loyola Marymount University during the fall 2015 semester. Check out the [wiki](https://github.com/lmucs/grapevine/wiki) and the (TODO final presentation).

**The Team**

* Rachel Rivera
* Nicole Anguiano
* Cameron Billingham
* Juan Carrillo
* Jeff Fennell
* Matt Flickner
* Joaquín Loustau

## Acknowledgments
Grapevine makes use of the following libraries, without which Grapevine would be impossible.
* [Chrono-Node](https://github.com/wanasit/chrono)
* [NLTK Python Libraries](http://www.nltk.org/)
* [Caldroid](https://github.com/roomorama/Caldroid)
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [CVCalendar](https://github.com/Mozharovsky/CVCalendar)
* [CocoaPods](https://cocoapods.org/)
