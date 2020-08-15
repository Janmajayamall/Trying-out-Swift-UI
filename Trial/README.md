#  <#Title#>

## Reference links
1. https://martinmitrevski.com/2019/07/20/developing-drawing-app-with-swiftui/ : Drawing pad on image
2. https://levelup.gitconnected.com/swiftui-create-a-custom-gradient-color-picker-like-snapchats-bcf508e69380 : Color Picker like snapchat
3. https://www.youtube.com/watch?v=R9uSUe3VO14      -   Try making such complex & good looking UI
4. https://stackoverflow.com/questions/57200521/how-to-convert-a-view-not-uiview-to-an-image  --- Use this for storing you ZStack view as an UIImage
5. https://stackoverflow.com/questions/56507839/swiftui-how-to-make-textfield-become-first-responder  --- UITextField Implementation 
6. https://swiftwithmajid.com/2019/11/27/combine-and-swiftui-views/    ---- KeyboardAware padding implementation & expaination of system wide publisher & suscribers
7. https://github.com/bbaars/SwiftUI-Gradient-ColorPicker  ---- reference for ColorPickerSlider
8. https://levelup.gitconnected.com/swiftui-integrating-the-mapbox-sdk-5a8098708b3c ---- guide to integrating MapBox with SwiftUI
9.  guides to core location: 
    a. https://fluffy.es/current-location/ 
    b. https://www.youtube.com/watch?v=kWAWmWZV0n4
10. Mapkit:
    a. Styling mapkit with google maps style https://medium.com/@ortizfernandomartin/customize-mapkits-mkmapview-with-google-maps-styling-wizard-a5dcc095e19f
11. Displaying user location annotation on mapbox map in using a 3d figure - https://blog.classycode.com/how-to-write-a-pok%C3%A9mon-go-clone-for-ios-edf1cf1cf5ce
12. ARKit + Core Location based navigation app: https://medium.com/journey-of-one-thousand-apps/arkit-and-corelocation-part-one-fc7cb2fa0150
    a. Another supporting link - https://sudonull.com/post/11751-How-Yandex-created-augmented-reality-in-Maps-for-iOS-Experience-using-ARKit
    b. https://medium.com/@yatchoi/getting-started-with-arkit-real-life-waypoints-1707e3cb1da2
    c. http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/#cumulating-transformations --- good tutorial on 3d transformations (with matrices)
    

## Work Left
1. Get documents from firestore in Main View and then display it. Remeber you are helping people relive memories & lock it in the physical space. You don't have to  give them option for friends, rather make  everything public. 
2. Integrate authentication
3. Adding & searching friends
4. Design

## Geohasing
This offers you a way to convert you latitude & longitude to a single string of characters, which increases in its precision as its length increases. It divides the surface of earth into small rectangles each represented by a unique string of characters. 

Using geohasing for your app:
1. Store geohash along with the coordinates of user's location 
2. For retrieving posts near user do the following:
    a. Get geohash for user's current location & nearby hashes
    b. Get all images with matching geohahes from firestore
    c. Reference for geohasing: https://www.movable-type.co.uk/scripts/geohash.html

## UI Design
1. lush lava guide: https://www.shutterstock.com/blog/orange-red-color-design-history-combinations
2. 2020 trendy colors: https://digitalsynopsis.com/design/2020-color-trends-worlds-most-popular-colors/
3. SF Symbols short guide: https://www.simpleswiftguide.com/how-to-use-sf-symbols-in-swiftui/


## Combine framework guides
1. https://www.vadimbulavin.com/swift-combine-framework-tutorial-getting-started/

