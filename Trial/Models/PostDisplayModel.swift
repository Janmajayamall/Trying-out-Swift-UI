//
//  PostDisplayModel.swift
//  Trial
//
//  Created by Janmajaya Mall on 30/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import SDWebImageSwiftUI
import CoreLocation

struct PostDisplayModel {
    var postData: PostModel
    var imageManager: ImageManager
    var image: UIImage? {
        guard let image = self.imageManager.image else {return nil}
        return image
    }
    var location: CLLocation {
        
        let cLLocation2d = CLLocationCoordinate2D(latitude: self.postData.geolocation.latitude, longitude: self.postData.geolocation.longitude)
        
        return CLLocation(coordinate: cLLocation2d, altitude: self.postData.altitude,horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: self.postData.timestamp.dateValue())
    }
    var id: String {
        return self.postData.id!
    }
    
    init(postData: PostModel) {
        self.postData = postData
        self.imageManager = ImageManager(url: URL(string: postData.imageUrl))
        self.imageManager.load()
        self.imageManager.setOnSuccess { (image) in
            print("Got the image: \(image)")            
        }
    }
    
    init(postData: PostModel, imageManager: ImageManager){
        self.postData = postData
        self.imageManager = imageManager
    }
    
    func checkImage() -> Bool {
        if self.imageManager.image != nil {
            return true
        }
        return false
    }
    
    //TODO: complete getImageSize()
    func getImageSize() -> Void {
        /**
         TODO: Do the following:
         1. calculate the distance of image coordinates from user's current coordinates.
         2. get the original size of the image
         3. scale the image size by how distant it is from the user.
         for example: the further the image is, smaller it should look. Also image at user's location should be of 3/4 size of the user. Hence, scale it according to that.
         */
    }
    
}



//    func getPostUIImage() -> UIView? {
//
//        if let image = self.imageManager.image {
//
//            let uiImageView = UIImageView(image: image)
//            uiImageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
//
//            let uiView = UIView(frame: uiImageView.frame)
//            uiView.addSubview(uiImageView)
////
////            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
////            let image = renderer.image { ctx in
////                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
////            }
////
//            return uiView
//        }
//
//        return nil
//    }
