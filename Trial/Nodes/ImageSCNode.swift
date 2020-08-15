//
//  ImageSCNode.swift
//  Trial
//
//  Created by Janmajaya Mall on 4/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation

class ImageSCNode: SCNNode {
    
    var location: CLLocation {
        return self.postDisplay.location
    }
    var postDisplay: PostDisplayModel
    var id: String? {
        return self.postDisplay.postData.id
    }
    
    /// Flag for singnaling whether asynchronously loaded image has been downloaded or not
    var didImageLoad: Bool {
        if self.postDisplay.image != nil {
            return true
        }else {
            return false
        }
    }
    
    /// With time, the accuracy of current location increases & it is possible that the nodes
    /// placed before were placed with lower accuracy. ---- NOT SURE IT THE ACCURACY DIFFERENCE IS SUBSTANTIAL
    /// Make this `True` for updating node position wiht more accuracy OR `False` for not updating it.
    /// Remember, the accuracy increase might not be substantial, but even a slight in image location change (image jumping around) after being rendered once will be bad experience for the user
    /// TODO: Test what works better.
    private var updateNodePositionAlways = false
    
    init(post: PostModel) {
        self.postDisplay = PostDisplayModel(postData: post)
        super.init()
    }
    
    /// adds post image as geometry to the node
    ///
    /// It does not adds image as geometry if image is not loaded, therefore make sure image has been loaded before calling this.
    /// If node geometry is not `nil` then image will not be added in order to avoid override of geometry.
    /// - Returns
    /// Boolean value indicating: `True` if image was added as geometry to the node now (indicating that it was first time this function was called for this node ~ as `self.geometry was nil`). `False` if image was already added & it was not the first time. It will return `False` also if image has not been loaded, but considering the point that this function should not be called before image being fully loaded, it would have no effect.
    func addImageAsGeometry() -> Bool {
        
        guard let image = self.postDisplay.image else {return false}
        
        //should only add geometry to the node if it is nil (~ only for the first time)
        guard self.geometry == nil else {return false}
        
        //creating 2D plane for texturing it with image
        let plane = SCNPlane(width: image.size.width, height: image.size.height)
        plane.firstMaterial?.diffuse.contents = image
        plane.firstMaterial?.lightingModel = .constant
        
        //add to the geometry of the node
        self.geometry = plane
        
        //setup rendering order to fix up flicker
        
        //add constraint so the 2D plane always points towards the pointOfView (i.e. the camera)
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = .Y
        self.constraints = [billboardConstraint]
             
        return true
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets `updateNodePositionAlaways` to true
    func alwaysUpdatePostion(){
        self.updateNodePositionAlways = true
    }
    
    func updateSceneNodeWith(locationService: ARSceneLocationService, scenePostion: SCNVector3?, firstTime: Bool){
        
        guard let currentLocation = locationService.currentLocation else {return}
        guard let scenePostion = scenePostion else {return}
        
        let translateCurrentLocationBy = currentLocation.getTranslation(to: self.location)
        let distanceBetween = currentLocation.distance(from: self.location)
        
        //Start scene transaction
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.1
        
        // for checking whether to render position (might change the position) of already rendered nodes again
        if (firstTime || self.updateNodePositionAlways){
            //translate the image from current position
            self.position = SCNVector3(
                scenePostion.x + Float(translateCurrentLocationBy.longitudeTranslation),
                scenePostion.y + Float(translateCurrentLocationBy.altitudeTranslation),
                scenePostion.z - Float(translateCurrentLocationBy.latitudeTranslation)
            )
        }
        
        // scale the position (SCALE should always change depending on the current location of user)
        // TODO: set the scale of by how distant the image is from the user
        
        //update the rendering order of the node
        self.renderingOrder = self.setRenderOrder(forDistance: distanceBetween)
        
        //End scene transaction
        SCNTransaction.commit()
    }
    
    /// Returns the render order for the node
    ///
    /// Nodes with greater render orders are rendered last.
    /// In our case, we want distant nodes to render before the near ones
    /// in order to avoid image flickering (if form the camera perspective one image overlays the other one)
    func setRenderOrder(forDistance distance: CLLocationDistance) -> Int{
        return Int.max - (1000 - Int(distance * 1000))
    }
    
}
