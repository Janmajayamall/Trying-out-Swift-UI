//
//  AllView.swift
//  Trial
//
//  Created by Janmajaya Mall on 19/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI
import CoreLocation

enum ScreenStateEnum {
    case normal
    case painting
    case description
    case finish
}


struct AllView: View {
    
    @State var screenState: ScreenStateEnum = .normal
    
    @EnvironmentObject var screenMangement: MainScreenManagementViewModel
    @EnvironmentObject var currentCanvas: EditingViewModel
    
    @State var actionSheetAvailable: Bool = false
    //for keeping when painting is in action
    @State var isPaintingInAction: Bool = false
    
    var body: some View {
        GeometryReader{ geometryProxy in
            ZStack{
                
                self.currentCanvas.selectedImage.getContentRect(contentRect: self.$currentCanvas.imageCanvasRect)
                
                /**
                 Place self.currentPathDrawing after ForEach
                 for displaying the current active path over rest of the paths
                 */
                ForEach(self.currentCanvas.painting.pathDrawings){ return $0 }
                self.currentCanvas.painting.currentDrawing
                
                //menu for normal screen
                if(self.screenState == .normal){
                    VStack{
                        HStack{
                            Button(action: {
                                self.screenMangement.activeCameraScreen = .feed
                            }, label: {
                                Image(systemName: "xmark").imageScale(.large)
                            }).padding(20)
                            Spacer()
                            Button(action: {
                                self.screenState = .painting
                            }, label: {
                                Image(systemName: "square.fill").imageScale(.large)
                            }).padding(20)
                        }
                        Spacer()
                        HStack{
                            Button(action: {
                                self.screenState = .painting
                            }, label: {
                                Image(systemName: "square.fill").imageScale(.large)
                            }).padding(20)
                            Spacer()
                            Button(action: {
                                self.screenState = .finish
                                self.actionSheetAvailable = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                                    self.currentCanvas.setFinalImage()
                                })
                            }, label: {
                                Image(systemName: "square.fill").imageScale(.large)
                            }).padding(20)
                        }
                    }.frame(width: geometryProxy.size.width, height: geometryProxy.size.height, alignment: .top)
                }
                
                if(self.screenState == .description){
                    Group{
                        Color.black.opacity(0.3)
                        FadeType(parentGeometryProxy: geometryProxy.size)
                    }
                    .onTapGesture {
                        self.screenState = .normal
                    }
                }
                
                if(self.screenState == .painting && !self.isPaintingInAction){
                    ImageDisplay(parentGeometryProxy: geometryProxy.size, screenState: self.$screenState)
                }
                
                
                
            }
            .actionSheet(isPresented: self.$actionSheetAvailable, content: {
                ActionSheet.init(title: Text("Share with"), message: Text("With whom do you want to share?"), buttons: [
                    ActionSheet.Button.default(Text("Private"), action: {
                        self.currentCanvas.isPostPublic = false
                        self.exitScreenPostUpload()
                    }),
                    ActionSheet.Button.default(Text("Public"), action: {
                        self.currentCanvas.isPostPublic = true
                        self.exitScreenPostUpload()
                    })
                ])
            })
            .onTapGesture {
                if(self.screenState == .normal){
                    self.screenState = .description
                }
            }
            .gesture(DragGesture(minimumDistance:0.01)
            .onChanged({value in
                
                switch(self.screenState){
                case .painting:
                    self.currentCanvas.painting.draw(atPoint: value.location)
                    
                    //for hiding painting menu when when user start painting while screen state is .painting
                    self.isPaintingInAction = true
                default:
                    print("No Action")
                }
                
                
            })
                .onEnded({value in
                    switch(self.screenState){
                    case .painting:
                        self.currentCanvas.painting.newDrawing()
                        
                        //for showing painting menu once user stops painting while screen state is still .painting
                        self.isPaintingInAction = false
                    default:
                        print("No Action")
                        
                    }
                })
            )
            
        }.onAppear(perform: {
            self.currentCanvas.checkLocationAuthStatus(withStatus: CLLocationManager.authorizationStatus())
        }
        )
    }
    
    private func exitScreenPostUpload(){
        self.currentCanvas.uploadUserPost()
        self.screenMangement.activeMainScreen = .singleSwipeUp
        self.screenMangement.activeCameraScreen = .feed
    }
}

struct AllView_Previews: PreviewProvider {
    static var previews: some View {
        AllView()
    }
}

//// MARK: struct GetRect
//struct GetRect: View {
//
//    @Binding var rect: CGRect
//
//    var body: some View {
//        GeometryReader { geometryProxy in
//            self.createView(proxy: geometryProxy)
//        }
//    }
//
//    func createView(proxy: GeometryProxy) -> some View {
//
//        DispatchQueue.main.async {
//            self.rect = proxy.frame(in: .global)
//            print("self.rect: ", self.rect )
//        }
//
//        return Rectangle().fill(Color.clear)
//    }
//}
//
