//
//  ARSceneLocationService.swift
//  Trial
//
//  Created by Janmajaya Mall on 4/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import CoreLocation
import ARKit

protocol ARSceneLocationServiceDelegate: class {
    var scenePosition: SCNVector3? { get }
    func aRSceneLocationService(didUpdateLocationEstimates locationEstimates: Array<ARSceneLocationEstimate>)
}


class ARSceneLocationService {
    
    private let locationService: LocationService = LocationService()
    var locationEstimates: Array<ARSceneLocationEstimate> = []
    weak var delegate: ARSceneLocationServiceDelegate?
    var updateEstimatesTimer: Timer?
    
    var currentLocation: CLLocation? {
        
        //for best location estimate
        let sortedEstimates = self.locationEstimates.sorted(by: {
            if $0.location.horizontalAccuracy == $1.location.horizontalAccuracy {
                return $0.location.timestamp > $1.location.timestamp
            }
            
            return $0.location.horizontalAccuracy < $1.location.horizontalAccuracy
        })
        
        guard let bestLocationEstimate = sortedEstimates.first else {return nil}
        guard let position = self.delegate?.scenePosition else {return nil}
        
        return bestLocationEstimate.translateLocation(to: position)
    }
            
    init() {
        self.locationService.delegate = self
    }
    
    func addLocationEstimate(location: CLLocation){
        guard let position = self.delegate?.scenePosition else {return}
        self.locationEstimates.append(ARSceneLocationEstimate(location: location, position: position))
    }
    
    func updateEstimates(){
        removeOldEstimations()
        
        self.delegate?.aRSceneLocationService(didUpdateLocationEstimates: self.locationEstimates)
    }
    
    func removeOldEstimations(){
        
        // it is in meters; scene limit in meters measured from the current position
        let aRSceneLimit: CGFloat = 100
        
        guard let position = self.delegate?.scenePosition else {return}
        //for visualising position in 2D space; x & z axis
        let currentPositionPoint = CGPoint(x: CGFloat(position.x), y: CGFloat(position.z))
        
        self.locationEstimates = self.locationEstimates.filter { locationEstimate -> Bool in
            //for visualising position in 2D space; x & z axis
            let estimatePositionPoint = CGPoint(x: CGFloat(locationEstimate.position.x), y: CGFloat(locationEstimate.position.z))
            
            //checking whether estimatePostionPoint is in range of assigned aRSceneLimit around current postion point
            let xDiff2 = pow(currentPositionPoint.x - estimatePositionPoint.x, 2)
            let yDiff2 = pow(currentPositionPoint.y - estimatePositionPoint.y, 2)
            // distance2 (^2) is the square of distance between currentPoisitionPoint and estimatePostionPoint
            let distance2 = xDiff2 + yDiff2
            let radius2 = pow(aRSceneLimit, 2)
            // now if radius^2 is smaller than distance2 (^2) then estimate point should be removed,
            // as the scene does not needs any postion beyond specified limit around the current position
            return radius2 > distance2
        }
        
    }
    
    func start() {
        self.stop()
        self.updateEstimatesTimer = Timer(timeInterval: 0.5, repeats: true, block: { [weak self] _ in
            self?.updateEstimates()
        })
    }
    
    func stop() {
        self.updateEstimatesTimer?.invalidate()
        self.updateEstimatesTimer = nil
    }
    
}

extension ARSceneLocationService: LocationServiceDelegate {
    
    func locationService(didUpdateLocation location: CLLocation) {
        self.addLocationEstimate(location: location)
    }
    
    func locationService(didFailWithError error: Error) {
        print("Location Service failed with error: \(error.localizedDescription)")
    }
    
}


class ARSceneLocationEstimate {
    var location: CLLocation
    var position: SCNVector3
    
    init(location: CLLocation, position: SCNVector3) {
        self.location = location
        self.position = position
    }
    
    func getTranslation(for position: SCNVector3) -> CLLocationTranslation {
        return CLLocationTranslation(
            latitudeTranslation: Double(self.position.z - position.z),
            longitudeTranslation: Double(position.x - self.position.x),
            altitudeTranslation: Double(position.y - self.position.y))
    }
    
    func translateLocation(to position: SCNVector3) -> CLLocation {
        let translatedBy = self.getTranslation(for: position)
        let translatedCLLocation = self.location.getLocationAfterTranslation(by: translatedBy)
        return translatedCLLocation

    }
}



