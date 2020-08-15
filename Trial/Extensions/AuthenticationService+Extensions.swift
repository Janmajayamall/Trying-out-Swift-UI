//
//  AuthenticationService+Extensions.swift
//  Trial
//
//  Created by Janmajaya Mall on 10/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import FirebaseAuth

extension AuthenticationService: UserProfileServiceDelegate {
    func userProfileService(didReceiveUserProfile profile: ProfileModel) {
        let userProfile = UserProfileModel(profile: profile)
        
    }
    
    func userProfileService(didNotReceiveProfileForUser user: User) {
        <#code#>
    }
    
    func userProfileService(didUpdateUserProfile profile: ProfileModel) {
        <#code#>
    }
    
    
}
