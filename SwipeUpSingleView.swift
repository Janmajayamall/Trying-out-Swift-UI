//
//  SwipeUpSingleView.swift
//  Trial
//
//  Created by Janmajaya Mall on 25/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI
import CoreLocation

enum SwipeScreenState {
    case up
    case down
}

struct SwipeUpSingleView: View {
    
    @State var showMenu: Bool = false
    @EnvironmentObject var screenMangement: MainScreenManagementViewModel
    @State var showSearch: Bool = true
    @State var showSignUpModal: Bool = false
    
    @State var yDragTranslation: CGFloat = 0
    @State var screenState: SwipeScreenState = .down
    
    var test = MainViewModel()
        
    @ViewBuilder
    var body: some View {
        if (self.screenMangement.activeMainScreen == .camera) {
            CameraView()
        }else{
            GeometryReader {geometryProxy in
                ZStack{
                    
//                    ARView(parentSize: geometryProxy.size)
                    
                    //                    Rectangle().size(width: geometryProxy.size.width, height: geometryProxy.size.height).fill(Color.blue)
                    
                    //                ScreenView1(parentGeometrySize: geometryProxy.size, activeScreenType: self.$activeScreenType, yDragTranslation: self.$yDragTranslation, zIndex: 0, screenType: .arScreen)
                    
//                    ScreenView1(parentGeometrySize: geometryProxy.size, screenState: self.$screenState, yDragTranslation: self.$yDragTranslation)
//
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                self.screenMangement.activeMainScreenOverlay = .profile
//                                AuthenticationService.shared.signOut()
                            },label: {
                                Image(systemName: "camera.circle.fill").font(Font.system(size: 20, weight: .bold)).foregroundColor(Color.primaryColor).padding(40)
                            })
                        }
                        Spacer()
                        HStack{
                            Button(action: {
                                self.checkAuth()                               
                            }, label: {
                                Image(systemName: "camera.circle.fill").font(Font.system(size: 20, weight: .bold)).foregroundColor(Color.primaryColor).padding(40)
                            })
                            
                            Spacer()
                        }
                        
                    }.frame(width: geometryProxy.size.width
                        , height: geometryProxy.size.height, alignment: .top)
                    
                   
                    ProfileView(parentSize: geometryProxy.size)
                        
                    ProfileImagePickerView(parentSize: geometryProxy.size)
                    
                    ProfileChangeUsernameView(parentSize: geometryProxy.size)
                }
                .gesture(
                    DragGesture()
                        .onChanged({value in
                            
                            
                            guard (self.screenState == .up && value.translation.height > 0) || (self.screenState == .down && value.translation.height < 0) else {return}
                            
                            self.yDragTranslation = value.translation.height
                            
                        })
                        .onEnded({value in
                            
                            if (self.screenState == .up && value.translation.height > 0) {
                                self.screenState = .down
                            }else if (self.screenState == .down && value.translation.height < 0){
                                self.screenState = .up
                            }
                            
                            self.yDragTranslation = 0
                            }
                    )
                )
                
                BottomSheetView(isOpen: self.$showSignUpModal, parentSize: geometryProxy.size) {
                    Login()
                }
                
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).background(Color.black).edgesIgnoringSafeArea(.all)
        }
    }
    
    func checkAuth(){
        
        if AuthenticationService.shared.user != nil { // FIXME: remove false
            self.screenMangement.activeMainScreen = .camera
        }else{
            self.showSignUpModal = true
        }
    }
    
}


struct ScreenView1: View {
    
    var parentGeometrySize: CGSize
    @Binding var screenState: SwipeScreenState
    @Binding var yDragTranslation: CGFloat
    @State var locations: Array<CLLocationCoordinate2D> = [CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06),CLLocationCoordinate2D(latitude: 65, longitude: 23),
                                                           CLLocationCoordinate2D(latitude: 61, longitude: 18.06)]
    
    var screeOffset: CGSize {
        
        if(self.screenState == .up) {
            return CGSize(width: .zero, height: self.yDragTranslation + 100)
        }else{
            return CGSize(width: .zero, height: parentGeometrySize.height + self.yDragTranslation)
        }
    }
    
    var body: some View {
        
        ZStack{
            ZStack{
                HStack{
                    Spacer()
                    Text("height")
                    Spacer()
                }.frame(height: 100)
                    .background(Color.black.opacity(0.5))
                    .gesture(
                        DragGesture()
                            .onChanged({value in
                                guard (self.screenState == .up && value.translation.height > 0) || (self.screenState == .down && value.translation.height < 0) else {return}
                                
                                self.yDragTranslation = value.translation.height
                            })
                            .onEnded({value in
                                
                                if (self.screenState == .up && value.translation.height > 0) {
                                    self.screenState = .down
                                }else if (self.screenState == .down && value.translation.height < 0){
                                    self.screenState = .up
                                }
                                
                                self.yDragTranslation = 0
                                }
                    ))
            }.frame(width: parentGeometrySize.width, height: parentGeometrySize.height, alignment: .top).zIndex(3)
            MapBoxUIKit(mapAnnotations: self.$locations)
        }
            //parentGeometrySize.height - ScreenView.peekHeight: peekHeight is used for displaying a bit of top of inactive screen
            .frame(width: parentGeometrySize.width, height: parentGeometrySize.height).cornerRadius(20)
            .offset(self.screeOffset).animation(.spring())
            .gesture(DragGesture())
        
    }
}

struct SwipeUpSingleView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeUpSingleView()
    }
}



//                Ellipse().fill(Color.purple).frame(width: self.parentGeometrySize.width * 0.7, height: 150, alignment: .top).offset(CGSize(width: .zero, height: -60))
//                .gesture(
//                    DragGesture()
//                        .onChanged({value in
//
//                            guard (self.screenState == .up && value.translation.height > 0) || (self.screenState == .down && value.translation.height < 0) else {return}
//
//                            self.yDragTranslation = value.translation.height
//
//                        })
//                        .onEnded({value in
//
//                            if (self.screenState == .up && value.translation.height > 0) {
//                                self.screenState = .down
//                            }else if (self.screenState == .down && value.translation.height < 0){
//                                self.screenState = .up
//                            }
//
//                            self.yDragTranslation = 0
//                            }
//                    ))
//
//                Circle().fill(Color.red).frame(width: self.parentGeometrySize.width * 0.2, height: self.parentGeometrySize.width * 0.2, alignment: .top).offset(CGSize(width: .zero, height: -60))

//
//.sheet(isPresented: self.$showSignUpModal, content: {
//    Login()
//})

//
//if (self.showMenu == true){
//    HStack{
//        Spacer()
//        Button(action: {
//            print("ad")
//        }, label: {
//            Text("Friends Only").font(.subheadline).foregroundColor(Color.white)
//            Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.white)
//        })
//    }.padding(20).animation(Animation.spring().delay(0.3))
//    HStack{
//        Spacer()
//        Button(action: {
//            print("ad")
//        }, label: {
//            Text("Friends Only").font(.subheadline).foregroundColor(Color.white)
//            Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.white)
//        })
//    }.padding(20).animation(Animation.spring().delay(0.4))
//    HStack{
//        Spacer()
//        Button(action: {
//            print("ad")
//        }, label: {
//            Text("Friends Only").font(.subheadline).foregroundColor(Color.white)
//            Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.white)
//        })
//    }.padding(20).animation(Animation.spring().delay(0.5))
//    HStack{
//        Spacer()
//        Button(action: {
//            self.showSearch = true
//        }, label: {
//            Text("Friends Only").font(.subheadline).foregroundColor(Color.white)
//            Image(systemName: "xmark").imageScale(.large).foregroundColor(Color.white)
//        })
//    }.padding(20).animation(Animation.spring().delay(0.6))
//}
