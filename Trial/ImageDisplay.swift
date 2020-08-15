//
//  ImageDisplay.swift
//  Trial
//
//  Created by Janmajaya Mall on 17/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct Drawing{
    var points: Array<CGPoint> = []
    
    mutating func addPoint(point:CGPoint){
        self.points.append(point)
    }
}

struct ImageDisplay: View {
    
    var parentGeometryProxy: CGSize
    @Binding var screenState: ScreenStateEnum
    @EnvironmentObject var currentCanvas: EditingViewModel
    
    var body: some View {
        
        ZStack{
            VStack{
                HStack{
                    Button(action: {
                        self.screenState = .normal
                    }, label: {
                        Image(systemName: "chevron.left").imageScale(.large).foregroundColor(Color.white)
                    }).padding(20)
                    Spacer()
                    Button(action: {
                        self.currentCanvas.painting.undoPathDrawing()
                    }, label: {
                        Image(systemName: "arrow.uturn.left.circle.fill").imageScale(.large).foregroundColor(Color.white)
                    }).padding(20)
                }
                Spacer()
            }
            
            //            VStack{
            //                HStack{
            //                    Spacer()
            //                    Button(action: {
            //                        print("something")
            //                    }, label: {
            //                        Image(systemName: "square.fill").imageScale(.large)
            //                    })
            //                }
            //                Spacer()
            //            }
            
            VStack{
                HStack{
                    Spacer()
                    ColorPickerSlider(selectedYCoord: self.currentCanvas.painting.selectedColorYCoord
                            )
                        .frame(width:ColorPickerSlider.colorPickerWidth + ColorPickerSlider.colorPickerExpandedCircleDia+5)
                        .padding(.top, self.parentGeometryProxy.height*0.15)
                }
                Spacer()
            }
            
            VStack{
                HStack{
                    StrokeWidthSlider(selectedYCoord: StrokeWidthSlider.calculateYCoordFromStrokeWidth(currentStrokeWidth: self.currentCanvas.painting.selectedStrokeWidth))
                        .frame(width:StrokeWidthSlider.minimumStrokeWidth+25)
                        .padding(.top, self.parentGeometryProxy.height*0.15)
                    Spacer()
                }
                Spacer()
            }
            
        }
        .frame(width:self.parentGeometryProxy.width,height: self.parentGeometryProxy.height, alignment: .top)
        
    }
        
}
