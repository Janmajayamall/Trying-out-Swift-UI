//
//  UserProfileModel.swift
//  Trial
//
//  Created by Janmajaya Mall on 10/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct UserProfileModel {
    
    var profile: ProfileModel?
    var firebaseAuthUser: User
    
    var profileImage: UIImage? {
        return profileImageManager.image
    }
    
    private var profileImageManager: ImageManager
    
    init(firebaseAuthUser: User) {
        self.firebaseAuthUser = firebaseAuthUser
    }
    
    mutating func updateUserProfile(to profile: ProfileModel){
        self.profile = profile
        self.profileImageManager = ImageManager(url: URL(string: profile.profileImageUrl))
    }
}
