<img src="https://github.com/lmucs/grapevine/blob/master/images/grapevine.PNG?raw=true" width=90 height=90>
# Grapevine


Grapevine is an application that automatically populates a user's calendar with events from Twitter and Facebook. Events are extracted by an intelligent agent that listens to feeds that the user follows.

## Extracting Events
Users provide Grapevine with a list of feeds on Facebook and Twitter that they wish to follow. We pull any new posts and tweets from Facebook and Twitter and identify meaningful events.

<img src="https://github.com/lmucs/grapevine/blob/master/images/frozen-fb-post-cropped.png" width="900">

 If there is a date in the post, then it is an event.
 
 <img src="https://github.com/lmucs/grapevine/blob/master/images/frozen-fb-post-faded-cropped.png" width="900">


If it finds any events, it stores them and pushes the events to the user. These events are put on the user's Grapevine calendar.

<img src="https://github.com/lmucs/grapevine/blob/master/images/android-calendar-view.png" width="300" style="margin-right=2em">
<img src="https://github.com/lmucs/grapevine/blob/master/images/iOSCalendarView.png" width="300">

Events have information such as start time and end time, tags, who posted the event, and a link to the original post.

<img src="https://github.com/lmucs/grapevine/blob/master/images/android-event-view.png" width="300" style="margin-right=2em">
<img src="https://github.com/lmucs/grapevine/blob/master/images/iOSEventDetail.png" width="300">


## Installation
### Client Applications
We are currently in the process of deploying our Android and iOS applications to Google's play store and Apple's app store.
In the meantime feel free to download our latest stable release and test out grapevine in the Android and iOS development kits.

* [Android Setup Instructions](https://github.com/lmucs/grapevine/wiki/Dev-Setup#android)
* [iOS Setup Instructions](https://github.com/lmucs/grapevine/wiki/Dev-Setup#ios)

### Grapevine API

Grapevine API is available at <http://docs.grapevineapi.apiary.io/#>  
You can also test our server locally by downloading the latest stable release. Our server is implemented using Node.js so it's quite easy to install. Just run the following from the root directory.
```
npm install
npm start
```
Our social-media and grapevine servers should now be running on localhost.  

If you'd like to run our tests you can run them with:
```
npm test
```

## About

It was created as part of the CMSI 401 class at Loyola Marymount University during the fall 2015 semester. Check out the [wiki](https://github.com/lmucs/grapevine/wiki) and the [final presentation](http://rtoal.github.io/cmsi401-fall2015-presentation/#/18).

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
* [Scikit Learn](http://scikit-learn.org/)
* [Caldroid](https://github.com/roomorama/Caldroid)
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [CVCalendar](https://github.com/Mozharovsky/CVCalendar)
* [CocoaPods](https://cocoapods.org/)
