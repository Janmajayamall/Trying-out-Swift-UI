//
//  PostModel.swift
//  Trial
//
//  Created by Janmajaya Mall on 26/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct PostModel: Codable {
    
    var imageName: String
    var description: String
    var timestamp: 	Timestamp
    var isActive: Bool
    var geolocation: GeoPoint
    var geohash: String
    var altitude: Double
    var isPublic: Bool
    var userId: String
    var imageUrl: String
    @DocumentID var id: String? = UUID().uuidString

}



