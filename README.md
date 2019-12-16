# LandRemark - iOS - Description

This assignment application is developed in Xcode Version 11.2.1
Language : Swift 5 

Backend-as-a-Service(BaaS): [Firebase](https://firebase.google.com ).

Overall MVC design patteren is followed with some modifications according to project requirements.

All code is written in native Swift language and no 3rd party libraries are used except suggested one(Firebase).


## Application Scope

Application helps users to view note annotation in maps , Upon tap note is shown in callout custom view with note text, owner and its location. User can also create note by tapping create note button in navigation and save them on the cloud, share it with other users too.

## References

Most of functionalities are already documented inside code along with URLs. Following are some documentations, video tutorials and blogs which were helpful:

1- Firebase :

a) [Firebase Documentation](https://firebase.google.com/docs/ios/setup)

b) [Firebase Tutorials](https://www.raywenderlich.com/3-firebase-tutorial-getting-started)

2- Other Functionalities :

a) [MKMapView Custom Annotaion](https://digitalleaves.com/blog/2016/12/building-the-perfect-ios-map-ii-completely-custom-annotation-views/)

b) [Modern Architecture and Best coding practices](https://www.appcoda.com/swift-class-best-practice/)

c) [Placemark, Reverse Geocoding](https://developer.apple.com/documentation/mapkit/mkmapview/converting_a_user_s_location_to_a_descriptive_placemark)

## Limitations

Application contains basic required functionality implemented but still has some limitations as below:

1 - On SignIn/SignUp forms messages and scrolling functionalities can be improved.

2 - On Maps user's annotations image and interaction can be improved though it is fulfilling our requirements.

3 - In create note screen, An option is given whether user wants note to be public or private but while fetching notes we are not querying only public note. It can be implemented on request with already existing field "is_public" in DB.

4 - Though application is tested with multiple accounts, notes, locations and simulators but still needs to be tested on real device.


## Things to do

1 - Unit Test

2 - UI Test

## Contributing
Pull requests are welcome. 
