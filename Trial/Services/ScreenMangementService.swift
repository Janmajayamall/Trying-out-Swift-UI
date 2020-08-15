//
//  ScreenMangementService.swift
//  Trial
//
//  Created by Janmajaya Mall on 15/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import Combine


enum MainScreenType {
    case singleSwipeUp
    case camera
}

enum MainScreenOverlays {
    case profile
    case none
}

enum ProfileScreenOverlay {
    case changeProfileImage
    case changeUsername
    case none
}


enum CameraScreenType {
    case feed
    case editing
}


class ScreenMangementService: ObservableObject {
    
    @Published var activeMainScreen: MainScreenType = .singleSwipeUp
    @Published var activeCameraScreen: CameraScreenType = .feed
    @Published var activeMainScreenOverlay: MainScreenOverlays = .none
    @Published var activeProfileScreenOverlay: ProfileScreenOverlay = .none
    
}
