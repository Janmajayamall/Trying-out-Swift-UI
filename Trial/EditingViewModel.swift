//
//  EditingViewModel.swift
//  Trial
//
//  Created by Janmajaya Mall on 22/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI
import Firebase
import CoreLocation
import FirebaseFirestore


class EditingViewModel: NSObject, ObservableObject {
    
    @Published var selectedImage: Image
    @Published var imageCanvasRect: CGRect = .zero
    @Published var painting: PaintingModel = PaintingModel()
    @Published var isLocationAuthorized: Bool = true {
        didSet{
            print(self.isLocationAuthorized, " this is done")
        }
    }
    
    var locationManager = CLLocationManager()    
    var currentLocation: CLLocation?
    var isPostPublic: Bool?
    var finalImage: UIImage?
    @Published var descriptionText: String = ""
//    self.currentCanvas.uploadUserPost(withText: "dawd", withImage: finalImage!)
    
    init(selectedImage :Image) {
        self.selectedImage = selectedImage
        
        super.init()
                
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.checkLocationAuthStatus(withStatus: CLLocationManager.authorizationStatus())
        self.locationManager.startUpdatingLocation()
    }
    
    func uploadUserPost() {
        
        //for checking whether all optional values are present or not
        guard let location = self.currentLocation else {return}
        guard let image = self.finalImage else {return}
        guard let isPublic = self.isPostPublic else {return}
        guard let user = AuthenticationService.shared.user else {return}
            
        
        if let imageJpegData = image.jpegData(compressionQuality: 0.8) {
            FirebaseStorage.uploadImageDataToStorage(withData: imageJpegData, forUser: user.uid, withCallback: { (imageName, imageUrl) in
                                                        
                //for creating a new upload post model
                let newPost = PostModel(imageName: imageName, description: self.descriptionText, timestamp: Timestamp(), isActive: true, geolocation: GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), geohash: "geohash", altitude: location.altitude, isPublic: isPublic, userId: user.uid, imageUrl: imageUrl)
                //uploading the post
                FirestoreInteractions.addNewPost(withPost: newPost)
            })
        }else{
            print("Unable to convert userImage UIImage to JpegData")
        }
        
    }
    
    func setFinalImage(){
        
        self.finalImage = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController?.view.toImage(rect: self.imageCanvasRect)
    }
    
    func checkLocationAuthStatus(withStatus status: CLAuthorizationStatus){
        print("adaasasa")
        switch status {
        case .denied:
            self.isLocationAuthorized = false
            self.locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            self.isLocationAuthorized = false
            self.locationManager.requestWhenInUseAuthorization()
        default:
            self.isLocationAuthorized = true
            print("Location Permission Granted")
        }
    }
    
    
}

extension EditingViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthStatus(withStatus: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {return}
        self.currentLocation = currentLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("something went wrong while getting location")
    }
}

struct PaintingModel {
    var selectedColor: Color = PaintingModel.initialSelectedColor
    var selectedColorYCoord: CGFloat = 0
    var selectedStrokeWidth: CGFloat = PaintingModel.initialStrokeWidth
    var pathDrawings: Array<PathDrawing> = []
    var currentDrawing: PathDrawing = PathDrawing(color: PaintingModel.initialSelectedColor, strokeWidth: PaintingModel.initialStrokeWidth)
    
    mutating func changeSelectedColor(to selectedColor: Color, withYCoord yCoord: CGFloat){
        self.selectedColor = selectedColor
        self.selectedColorYCoord = yCoord
        self.newDrawing()
    }
    
    mutating func changeSelectedStrokeWidth(to selectedStrokeWidth: CGFloat){
        self.selectedStrokeWidth = selectedStrokeWidth
        self.newDrawing()
    }
    
    mutating func draw(atPoint point: CGPoint){
        self.currentDrawing.addPoint(point: point)
    }
    
    mutating func newDrawing() -> Void {
        if(!self.currentDrawing.isEmpty()){
            self.pathDrawings.append(self.currentDrawing)
        }
        
        self.currentDrawing = PathDrawing(color: self.selectedColor, strokeWidth: self.selectedStrokeWidth)
    }
    
    mutating func undoPathDrawing(){
        //For undo action simply remove the last drawing object from drawings array
        if (self.pathDrawings.count>0){
            self.pathDrawings.removeLast()
        }
    }
    
    private static var initialSelectedColor: Color = Color(UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1))
    private static var initialStrokeWidth: CGFloat = 15
}

struct PathDrawing: View, Identifiable {
    var id: UUID = UUID()
    var color: Color
    var points: Array<CGPoint>  = []
    var strokeWidth: CGFloat
    
    var body: some View {
        Path { path in
            self.makeDrawing(points: self.points
                , toPath: &path)
        }
        .stroke(self.color, style:
            StrokeStyle(
                lineWidth: self.strokeWidth,
                lineCap: .round,
                lineJoin: .round
        ))
            .background(Color.clear)
    }
    
    mutating func addPoint(point: CGPoint){
        self.points.append(point)
    }
    
    func makeDrawing(points: Array<CGPoint>, toPath path: inout Path){
        
        //if no points then return
        
        guard points.count>=1 else {
            return
        }
        
        for index in 0..<points.count-1 {
            let currentPoint = points[index]
            let nextPoint = points[index+1]
            path.move(to: currentPoint)
            path.addLine(to: nextPoint)
        }
    }
    
    func isEmpty() -> Bool {
        return self.points.isEmpty
    }
    
}


// MARK: func toImage : Extending UIView to convert CGRect, obtained from view, to UIImage
extension UIView{
    func toImage(rect: CGRect) -> UIImage{
        //UIGraphicsImageRenderer is used for creating CG backed Image when supplied with bounds
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image{(context) in
            self.layer.render(in: context.cgContext)
        }
    }
}
