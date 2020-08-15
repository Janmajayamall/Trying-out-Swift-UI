//
//  ContentView.swift
//  Trial
//
//  Created by Janmajaya Mall on 16/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI
import Foundation


struct ContentView: View {
    
    @State var currentScreen: Int = 0
    @State var mainOffset: CGSize = .zero
    
    
    func calculateInitialOffset(for index:Int, geometry dimensions: CGSize) -> CGSize{
        return CGSize.zero
    }
    
    var body: some View {
        
        GeometryReader {geometry in
            VStack{
                Text("Hello")
                
                ZStack{
                    SwipeableView(bgColor: Color.blue, screenIndex: 0, geometrySize: geometry.size ,mainOffset: self.$mainOffset, currentScreen: self.$currentScreen)
                    SwipeableMapView(bgColor:Color.green, screenIndex: 1, geometrySize: geometry.size, mainOffset: self.$mainOffset, currentScreen: self.$currentScreen)
                }
                
                
            }
        }
    }
}

struct SwipeableView: View {
    
    var bgColor: Color
    var screenIndex: Int
    var geometrySize: CGSize
    
    @Binding var mainOffset: CGSize
    @Binding var currentScreen: Int
    
    private var offset: CGSize {
        if(self.currentScreen==self.screenIndex){
            return self.mainOffset
        }else{
            if(self.screenIndex==0){
                return CGSize(width: -self.geometrySize.width+self.mainOffset.width, height: 0)
            }else if(self.screenIndex==1){
                return CGSize(width: self.geometrySize.width+self.mainOffset.width, height: 0)
            }
        }
        
        return .zero
    }
    
    
    var body: some View {
        VStack{
            Rectangle()
                .foregroundColor(self.bgColor)
        }
        .gesture(DragGesture()
        .onChanged({(value)-> Void in            
            //pass only if currentScreen = 0 & left swipe OR if currentScreen = 1 & right swipe
            guard((self.currentScreen==0 && value.translation.width<0) || (self.currentScreen==1 && value.translation.width>0)) else {return}
            
            self.mainOffset = CGSize(width: value.translation.width, height: 0)
        })
            .onEnded({(value)-> Void in
                //for left swipe (width<0) change screen only if translation is halfway across the screen
                if(self.currentScreen==0 && value.translation.width<0 && -value.translation.width>self.minimumTranslationForSwitch){
                    self.currentScreen = 1
                }
                    //for right swipe (width>0) change screen only when translation is halfway across the screen
                else if(self.currentScreen==1 && value.translation.width>0 && value.translation.width>self.minimumTranslationForSwitch){
                    self.currentScreen = 0
                }
                
                //set restore to before swipe state
                self.mainOffset = .zero
            })
        ).offset(self.offset)
            .animation(.spring())
    }
    
    // Mark: Private Constants
    private let minimumTranslationForSwitch: CGFloat = 30
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct SwipeableMapView: View {
    
    var bgColor: Color
    var screenIndex: Int
    var geometrySize: CGSize
    
    @Binding var mainOffset: CGSize
    @Binding var currentScreen: Int
    
    private var offset: CGSize {
        if(self.currentScreen==self.screenIndex){
            return self.mainOffset
        }else{
            if(self.screenIndex==0){
                return CGSize(width: -self.geometrySize.width+self.mainOffset.width, height: 0)
            }else if(self.screenIndex==1){
                return CGSize(width: self.geometrySize.width+self.mainOffset.width, height: 0)
            }
        }
        
        return .zero
    }
    
    
    var body: some View {
        VStack{
//            MapBoxUIKit()
            Text("fafa")
        }
        .gesture(DragGesture()
        .onChanged({(value)-> Void in
            //pass only if currentScreen = 0 & left swipe OR if currentScreen = 1 & right swipe
            guard((self.currentScreen==0 && value.translation.width<0) || (self.currentScreen==1 && value.translation.width>0)) else {return}
            
            self.mainOffset = CGSize(width: value.translation.width, height: 0)
        })
            .onEnded({(value)-> Void in
                //for left swipe (width<0) change screen only if translation is halfway across the screen
                if(self.currentScreen==0 && value.translation.width<0 && -value.translation.width>self.minimumTranslationForSwitch){
                    self.currentScreen = 1
                }
                    //for right swipe (width>0) change screen only when translation is halfway across the screen
                else if(self.currentScreen==1 && value.translation.width>0 && value.translation.width>self.minimumTranslationForSwitch){
                    self.currentScreen = 0
                }
                
                //set restore to before swipe state
                self.mainOffset = .zero
            })
        ).offset(self.offset)
            .animation(.spring())
    }
    
    // Mark: Private Constants
    private let minimumTranslationForSwitch: CGFloat = 30
    
}
