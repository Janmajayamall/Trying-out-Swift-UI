//
//  LocationManager.swift
//  Trial
//
//  Created by Janmajaya Mall on 2/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func locationService(didUpdateLocation location: CLLocation)
    func locationService(didFailWithError error: Error)
}

extension LocationServiceDelegate {
    func locationService(didUpdateHeading heading: CLHeading) {}
}

class LocationService: NSObject {
    
    var manager: CLLocationManager?
    var delegate: LocationServiceDelegate?
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?    
    
    
    override init() {
        self.manager = CLLocationManager()
        
        super.init()
        
        self.manager!.desiredAccuracy = kCLLocationAccuracyBest
        self.manager!.distanceFilter = kCLDistanceFilterNone
        self.manager!.headingFilter = kCLHeadingFilterNone
        
        //take care of authorization
        // TODO: MAKE REQUEST AUTHRORIZATION PROPER
        self.manager!.requestWhenInUseAuthorization()
        
        self.manager!.startUpdatingLocation()
        
    }
    
    /**
     For activating heading updates
     */
    func activateHeadingUpdates(){
        guard self.manager != nil else {return}
        self.manager?.startUpdatingHeading()
    }
}


extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { (location) in
            self.currentLocation = location
            delegate?.locationService(didUpdateLocation: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        delegate?.locationService(didUpdateHeading: newHeading)
        self.currentHeading = newHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationService(didFailWithError: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to: \(status.rawValue)")
    }
}
