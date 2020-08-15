//
//  SwipeUpView.swift
//  Trial
//
//  Created by Janmajaya Mall on 19/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI
import CoreLocation

enum ScreenTypes {
    case arScreen
    case mapScreen
}

struct SwipeUpView: View {
    
    @State var activeScreenType: ScreenTypes = .arScreen
    @State var yDragTranslation: CGFloat = 0
    @State var showMenu: Bool = false
    
    @State var showSearch: Bool = false
    
    var body: some View{
        
        GeometryReader {geometryProxy in
            ZStack{
                
                ScreenView(parentGeometrySize: geometryProxy.size, activeScreenType: self.$activeScreenType, yDragTranslation: self.$yDragTranslation, zIndex: 0, screenType: .arScreen)
                ScreenView(parentGeometrySize: geometryProxy.size, activeScreenType: self.$activeScreenType, yDragTranslation: self.$yDragTranslation, zIndex: 1, screenType: .mapScreen)
                VStack{
                    HStack{
                        Spacer()
                        VStack{
                            HStack{
                                Spacer()
                                Button(action: {
                                    withAnimation(Animation.spring(),{
                                        self.showMenu = !self.showMenu
                                    })
                                    
                                }, label: {
                                    Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.black)
                                })
                            }.padding(20)
                            if (self.showMenu == true){
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        print("ad")
                                    }, label: {
                                        Text("Friends Only").font(.subheadline).foregroundColor(Color.white)
                                        Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.white)
                                    })
                                }.padding(20).animation(Animation.spring().delay(0.3))
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        print("ad")
                                    }, label: {
                                        Text("Friends Only").font(.subheadline).foregroundColor(Color.white)
                                        Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.white)
                                    })
                                }.padding(20).animation(Animation.spring().delay(0.4))
                               HStack{
                                    Spacer()
                                    Button(action: {
                                        print("ad")
                                    }, label: {
                                        Text("Friends Only").font(.subheadline).foregroundColor(Color.white)
                                        Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.white)
                                    })
                                }.padding(20).animation(Animation.spring().delay(0.5))
                               HStack{
                                    Spacer()
                                    Button(action: {
                                        self.showSearch = true
                                    }, label: {
                                        Text("Friends Only").font(.subheadline).foregroundColor(Color.white)
                                        Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.white)
                                    })
                                }.padding(20).animation(Animation.spring().delay(0.6))
                            }
                        }
                    }
                    Spacer()
                }.frame(width: geometryProxy.size.width
                    , height: geometryProxy.size.height, alignment: .top).zIndex(1.5)
                
                if (self.showSearch == true) {
                    VStack {
                        Button(action: {
                            self.showSearch = false
                        }, label: {
                            Text("adadasa")
                        })
                    }.frame(width: geometryProxy.size.width
                        , height: geometryProxy.size.height, alignment: .top).zIndex(2).background(Color.black.opacity(0.7))
                }
            }
            
        }
        
    }
    
}

struct ScreenView: View {
    
    var parentGeometrySize: CGSize
    @Binding var activeScreenType: ScreenTypes
    @Binding var yDragTranslation: CGFloat
    @State var zIndex: Double
    var screenType: ScreenTypes
    @State var locations: Array<CLLocationCoordinate2D> = [CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06),CLLocationCoordinate2D(latitude: 65, longitude: 23),
    CLLocationCoordinate2D(latitude: 61, longitude: 18.06)]
    
    
    var screeOffset: CGSize {
        if(self.screenType == self.activeScreenType) {
            //-1*self.yDragTranslation: for pulling down the active screen while the inactive screen is being pulled
            return CGSize(width: .zero, height: -1*self.yDragTranslation)
        }else{
            return CGSize(width: .zero, height: parentGeometrySize.height + self.yDragTranslation - ScreenView.peekHeight)
        }
    }
    
    var body: some View {
        VStack{
            if(self.screenType == .arScreen){
                Image("ProfileImage").resizable()
            }else{
                HStack{
                    Spacer()
                    Text("Hello").foregroundColor(Color.black)
                    Spacer()
                }.background(Color.white)
                Text("Uncomment the line below")
//                MapBoxUIKit(mapAnnotations: self.$locations)
            }
        }
            //parentGeometrySize.height - ScreenView.peekHeight: peekHeight is used for displaying a bit of top of inactive screen
            .frame(width: parentGeometrySize.width, height: parentGeometrySize.height - ScreenView.peekHeight)
            .gesture(
                DragGesture()
                    .onChanged({value in
                        //for returning if user drags an active screen
                        guard self.screenType != self.activeScreenType else {return}
                        //for returning is drag in downwards (i.e. postive in value)
                        guard value.translation.height < 0 else {return}
                        
                        //setting the translation upwards for inactice screen
                        self.yDragTranslation = value.translation.height
                        //for enaling inactive screen to show above active screen in zstack while being dragged
                        self.zIndex = 1
                    })
                    .onEnded({value in
                        
                        //for returing if drag in downwards (i.e. positive in value)
                        guard value.translation.height < 0 else {return}
                        
                        withAnimation(.spring(response: ScreenView.slideAnimationDuration), {
                            if(self.screenType != self.activeScreenType){
                                
                                //for setting up the current not active screen (i.e. being dragged up) to active
                                self.activeScreenType = self.screenType
                                
                                /**
                                 zIndex adjusts which screen is shown at the top.
                                 onEnded is triggered right after user leaves the touch screen, irrespectve of at which point the drag is.
                                 Hence, this results in zIndex for the soon to become active screen equal to zero way before it reaches top in slide animation, causing glitchy view.
                                 Therefore, zIndex is made after the transistion ends and that is determined by ScreenView.slideAnimationDuration
                                 */
                                DispatchQueue.main.asyncAfter(deadline: .now() + ScreenView.slideAnimationDuration, execute: {
                                    self.zIndex = 0
                                })
                                
                            }})
                        
                        //Once sliding of screens end, return yDragTranslation to 0.
                        self.yDragTranslation = 0
                        
                        }
                        
            )).offset(self.screeOffset).animation(.spring(response: ScreenView.slideAnimationDuration)).zIndex(self.zIndex)
    }
    
    static private var peekHeight: CGFloat = 75
    static private var slideAnimationDuration: Double = 0.75
}

struct PanelView: View {
    
    var geometry: CGSize
    
    //current Height is measured from the bottom
    @Binding var currentHeight: CGFloat
    @Binding var swipeState: Int
    
    var offset: CGSize {
        CGSize(width: 0, height: self.geometry.height - self.currentHeight)
    }
    
    var body: some View {
        VStack{
            Image("ProfileImage")
                .resizable().cornerRadius(30)
        }.offset(self.offset)
            .animation(.spring())
    }
    
    static private var peekHeight: CGFloat = 0
    static private var maxSwipeUpStretchHeightPer: CGFloat = 0.7
    static private var maxSwipeUpHeightPer: CGFloat = 0.5
    
}

struct OtherView: View {
    
    var body: some View {
        VStack{
            Text("Hello")
        }
    }
}

struct SwipeUpView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeUpView()
    }
}
