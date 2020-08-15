//
//  GeohasingService.swift
//  Trial
//
//  Created by Janmajaya Mall on 2/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//
import Foundation
import CoreLocation

enum Direction {
    case north
    case south
    case east
    case west
}

protocol GeohasingServiceDelegate: class {

    func geohashingService(didUpdateGeohash currentLocationGeohash: String, didUpdateGeohashArea currentAreaGeohashes: Array<String>)

}

class GeohashingService {
    
    var currentLocationGeohash: String?
    var currentAreaGeohashes: [String]?
    weak var delegate: GeohasingServiceDelegate?
    
    /**
     Updates geohash to current location.
     Returns whether the geohash of new location is different from geohash of last location, indicating whether the region of the user has changed
     
     - Parameters:
        - location: new Location
     */
    func updateGeohashToLocation(_ location: CLLocation) {
        
        let locationGeohash = self.getGeohash(forCoordinates: location.coordinate)
        
        guard self.currentLocationGeohash == nil || self.currentLocationGeohash != locationGeohash else {return}
        
        self.currentLocationGeohash = locationGeohash
        self.currentAreaGeohashes = self.neighborsFor(geohash: locationGeohash)
        
        delegate?.geohashingService(didUpdateGeohash: self.currentLocationGeohash!, didUpdateGeohashArea: self.currentAreaGeohashes!)
            
    }
    
    func getGeohash(forCoordinates locationCoordinates: CLLocationCoordinate2D , precision: Int = 8) -> String {
        
        let lat: Double = locationCoordinates.latitude
        let lon: Double = locationCoordinates.longitude
        
        var index: Int = 0
        var bit: Int = 0
        var evenBit: Bool  = true
        var geohash: String = ""
        var latMin: Double = -90
        var latMax: Double = 90
        var lonMin: Double = -180
        var lonMax: Double = 180
        
        while geohash.count < precision {
            
            if (evenBit == true){
                let lonMid = (lonMin + lonMax)/2
                
                if(lon >= lonMid){
                    index = (index * 2) + 1
                    lonMin = lonMid
                }else{
                    index = index * 2
                    lonMax = lonMid
                }
            }else{
                let latMid = (latMin + latMax)/2
                
                if(lat >= latMid){
                    index = (index * 2 ) + 1
                    latMin = latMid
                }else{
                    index = index * 2
                    latMax = latMid
                }
            }
            
            evenBit = !evenBit
            
            bit += 1
            if(bit == 5){
                geohash = geohash + "\(GeohashingService.base32[index])"
                bit = 0
                index = 0
            }
            
        }
        
        return geohash
        
    }
    
    func adjacent(geohash: String, direction: Direction) -> String {
        
        var geohashLowercase = geohash.lowercased()
        guard geohashLowercase.count > 0 else {return ""}
        
        let neighbour: [Direction : Array<Array<Character>>] = [
            .north: [ Array("p0r21436x8zb9dcf5h7kjnmqesgutwvy"), Array("bc01fg45238967deuvhjyznpkmstqrwx") ],
            .south: [ Array("14365h7k9dcfesgujnmqp0r2twvyx8zb"), Array("238967debc01fg45kmstqrwxuvhjyznp") ],
            .east: [ Array("bc01fg45238967deuvhjyznpkmstqrwx"), Array("p0r21436x8zb9dcf5h7kjnmqesgutwvy") ],
            .west: [ Array("238967debc01fg45kmstqrwxuvhjyznp"), Array("14365h7k9dcfesgujnmqp0r2twvyx8zb") ]
        ]
        
        let border: [Direction : Array<Array<Character>>] = [
            .north: [ Array("prxz"),     Array("bcfguvyz") ],
            .south: [ Array("028b"),    Array("0145hjnp") ],
            .east: [ Array("bcfguvyz"),  Array("prxz")     ],
            .west: [ Array("0145hjnp"),  Array("028b")     ]
        ]
        
        let lastChar = geohashLowercase.removeLast()
        let typeV = geohashLowercase.count % 2
        
        if (border[direction]![typeV].contains(lastChar) && geohashLowercase.count > 0){
            geohashLowercase = self.adjacent(geohash: geohashLowercase, direction: direction)
        }
                
        return geohashLowercase + "\(GeohashingService.base32[neighbour[direction]![typeV].firstIndex(of: lastChar)!])"
    }
    
    func neighborsFor(geohash: String) -> Array<String> {
        
        let north = self.adjacent(geohash: geohash, direction: .north)
        let south = self.adjacent(geohash: geohash, direction: .south)
        let east = self.adjacent(geohash: geohash, direction: .east)
        let west = self.adjacent(geohash: geohash, direction: .west)
        
        return ([
            north,
            self.adjacent(geohash: north, direction: .east), // north east
            self.adjacent(geohash: north, direction: .west), // north west
            south,
            self.adjacent(geohash: south, direction: .east), // south east
            self.adjacent(geohash: south, direction: .west), // south west
            east,
            west
        ])
        
    }
    
    static private let base32: Array<Character> = Array("0123456789bcdefghjkmnpqrstuvwxyz") // (geohash-specific) Base32
    
    
}
