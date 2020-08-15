//
//  ProfileModel.swift
//  Trial
//
//  Created by Janmajaya Mall on 10/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ProfileModel: Codable {
    
    var username: String
    var profileImageUrl: String
    @DocumentID var id: String? = UUID().uuidString
            
}
