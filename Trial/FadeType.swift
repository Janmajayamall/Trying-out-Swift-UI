//
//  FadeType.swift
//  Trial
//
//  Created by Janmajaya Mall on 19/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI
import Combine

struct FadeType: View {
    
    //    @State var colorOpacity: Double = 0
    @State var textViewHeight: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    
    var parentGeometryProxy: CGSize
    @EnvironmentObject var currentCanvas: EditingViewModel
    
    
    //    var body: some View {
    //        GeometryReader{geometryProxy in
    //            ZStack{
    //
    //                Image("ProfileImage")
    //
    //
    //
    //                if(self.colorOpacity==0.5){
    //                    VStack(){
    //                        Text("What's up?").font(.headline).foregroundColor(.purple)
    //
    //                        CustomMultiLineTextField(text: self.$message, isFirstResponder: true, textViewHeight: self.$textViewHeight)
    //                            .keyboardAwareExpandingHeightFrame(currentHeight: self.$textViewHeight, parentSize: geometryProxy.size, alreadyOccupiedHeight: 30)
    //                            .onTapGesture {
    //                                print("To disable parent tap gesture event")
    //                        }
    //
    //                    }
    //                    .frame(width:geometryProxy.size.width, height: geometryProxy.size.height, alignment: .top)
    //                    .transition(.opacity)
    //                }
    //            }.onTapGesture {
    //                withAnimation(Animation.default, {
    //                    if(self.colorOpacity==0){
    //                        self.colorOpacity = 0.5
    //                    }else{
    //                        self.colorOpacity = 0
    //                    }
    //                })
    //            }
    //        }
    //    }
    
    var body: some View {
        VStack(){
            Text("What's up?").font(.headline).foregroundColor(.purple)
            CustomMultiLineTextField(text: self.$currentCanvas.descriptionText, isFirstResponder: true, textViewHeight: self.$textViewHeight)
                .keyboardAwareExpandingHeightFrame(currentHeight: self.$textViewHeight, parentSize: self.parentGeometryProxy, alreadyOccupiedHeight: 30)
                .onTapGesture {
                    print("To disable parent tap gesture event")
            }
            
        }
        .frame(width:self.parentGeometryProxy.width, height: self.parentGeometryProxy.height, alignment: .top)
        .transition(.opacity)
        
        
    }
}

//struct FadeType_Previews: PreviewProvider {
//    static var previews: some View {
//        FadeType()
//    }
//}
