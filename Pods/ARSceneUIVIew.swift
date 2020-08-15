//
//  ARSceneUIVIew.swift
//  Trial
//
//  Created by Janmajaya Mall on 5/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class ARSceneUIView: ARSCNView {
    
    /// The first node of  ARSCNView scene's rootNode.
    /// Did this for convenience; To avoid refering to the rootNode of view's secene again and again
    /// Main root node and `mainSceneNode` have same position (i.e. the origin of 3d scene coordinate )
    var mainSceneNode: SCNNode? {
        didSet{
            //return if mainSceneNode is still nil
            guard self.mainSceneNode != nil else {return}
            
            self.imageNodes.forEach { (id, node) in
                // for checking whether the post image has been loaded asynchronously or not
                guard node.didImageLoad == true else {return}
                // adding image as geometry (possible that image just loaded & addImageGeometry hasn't been called before for this node)
                _ = node.addImageAsGeometry()
                // passing firstTime as `True` because mainSceneNode has just been assigned a new value & each node must be positioned again to be placed correctly in 3D coordinate space
                node.updateSceneNodeWith(locationService: self.aRSceneLocationService, scenePostion: self.currentPosition ,firstTime: true)
    
                self.mainSceneNode?.addChildNode(node)
            }
        }
    }
    var currentPosition: SCNVector3? {
        guard let pointOfView = self.pointOfView else {return nil}
        return self.scene.rootNode.convertPosition(pointOfView.position, to: mainSceneNode)
    }
    
    var aRSceneLocationService = ARSceneLocationService()
    var firestoreService = FirestoreService()
    var geohashingService = GeohashingService()
    
    var imageNodes: Dictionary<String , ImageSCNode> = [:]
    
    var debug: Bool = false
    
    init(parentSize: CGSize){
        super.init(frame: CGRect(x: 0, y: 0, width: parentSize.width, height: parentSize.height), options: nil)
        
        //setting up debug options
        if (self.debug){
            self.debugOptions = ARSCNDebugOptions(arrayLiteral: [.showWorldOrigin, .showFeaturePoints])
            self.showsStatistics = true
        }
        
        // assigning service delegates
        self.aRSceneLocationService.delegate = self
        self.firestoreService.delegate = self
        self.geohashingService.delegate = self
        // TODO: Change delegate afterwards - when you need to have a delegate for this class
        self.delegate = self
        
        // adding UITapGestureRecogniser
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleViewTap(sender:)))
        self.addGestureRecognizer(gestureRecogniser)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleViewTap(sender: UITapGestureRecognizer){
        // checking whether the touch is from class og type SCNView or not
        guard let view = sender.view as? SCNView else {return}
        
        // getting the touch location as 2 coordinates on screen
        let coordinates = sender.location(in: view)
        // getting the nodes with which the ray sent along the path of touchpoint would have interacted
        guard let touchedNode = view.hitTest(coordinates).first else {return}
        
        //TODO: notify the delegate of touched node.
        
        
    }
    
    func startSession(){
        //configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = false
        configuration.worldAlignment = .gravityAndHeading
        
        //run the session
        self.session.run(configuration)
    }

    func pauseSession(){
        self.session.pause()
        
        //stop other services as well
        self.firestoreService.stopListeningToPosts()
        self.aRSceneLocationService.stop()
    }
    
    func updateSceneNodes(){
        
        self.imageNodes.forEach { (id, node) in
            // for checking post image has been loaded or not
            guard node.didImageLoad == true else {return}

            let firstTime = node.addImageAsGeometry()

            node.updateSceneNodeWith(locationService: self.aRSceneLocationService, scenePostion: self.currentPosition, firstTime: firstTime)
            
            // if firstTime is true, then the node should be added as child to rootNodeChild
            if(firstTime == true){
                self.mainSceneNode?.addChildNode(node)
            }
        }
    }
 
}

extension ARSceneUIView: FirestoreServiceDelegate {
     func firestorePostsUpdated(_ posts: Array<PostModel>){
         posts.forEach { (post) in
             
             // checking whether the post image has already been rendered or not
             guard let id = post.id, self.imageNodes[id] == nil else {return}
      
             // create AR scene image node for the post
             let imageNode = ImageSCNode(post: post)
             self.imageNodes[id] = imageNode
         }
        
        // Waiting for images to load & then updating scene
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.updateSceneNodes()
        })
     }
}

extension ARSceneUIView: ARSceneLocationServiceDelegate {

    func aRSceneLocationService(didUpdateLocationEstimates locationEstimates: Array<ARSceneLocationEstimate>) {
        self.updateSceneNodes()
        
        // updating current location for geohashing service
        if let currentLocation = self.aRSceneLocationService.currentLocation {
            self.geohashingService.updateGeohashToLocation(currentLocation)
        }
    }
    
    var scenePosition: SCNVector3? {
        return self.currentPosition
    }
    
}

extension ARSceneUIView: GeohasingServiceDelegate {
    
    func geohashingService(didUpdateGeohash currentLocationGeohash: String, didUpdateGeohashArea currentAreaGeohashes: Array<String>) {
        
        // registering firestore post listener for updated area geohashes
        self.firestoreService.listenToPosts(forAreaGeohashes: currentAreaGeohashes)
    }
    
}


extension ARSceneUIView: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if(self.mainSceneNode == nil){
            self.mainSceneNode = SCNNode()
            
            //adding the mainSceneNode as the first child of root node of the scene
            scene.rootNode.addChildNode(mainSceneNode!)
        }
    }
}


