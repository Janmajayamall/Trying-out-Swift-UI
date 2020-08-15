//
//  StrokeWidthSlider.swift
//  Trial
//
//  Created by Janmajaya Mall on 21/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct StrokeWidthSlider: View {
    
    @EnvironmentObject var currentCanvas: EditingViewModel
    
    @State var selectedYCoord: CGFloat {
        didSet{
            self.currentCanvas.painting.changeSelectedStrokeWidth(to: StrokeWidthSlider.minimumStrokeWidth + ((self.selectedYCoord/StrokeWidthSlider.strokeSliderHeight)*StrokeWidthSlider.strokeAmplification)
            )
        }
    }
    
    var body: some View {
        ZStack(alignment:.top){
            Rectangle()
                .fill(self.currentCanvas.painting.selectedColor)
                .frame(width:3, height: StrokeWidthSlider.strokeSliderHeight)
                .cornerRadius(1.5)
                .shadow(radius:8)
                .gesture(DragGesture(minimumDistance: 0).onChanged({value in
                    self.selectedYCoord = self.coordPostDrag(startedFromY: value.location.y)
                }))
            Circle()
                .foregroundColor(self.currentCanvas.painting.selectedColor)
                .frame(width:self.currentCanvas.painting.selectedStrokeWidth, height: self.currentCanvas.painting.selectedStrokeWidth)
                .offset(x:0, y:self.selectedYCoord)
                .gesture(
                    DragGesture()
                        .onChanged({ value in                        
                            self.selectedYCoord = self.coordPostDrag(startedFromY: value.location.y)
                        })
            )
        }
    }
    
    func coordPostDrag(startedFromY: CGFloat) -> CGFloat {
        //getting new coordinate for calculating color
        var newY = startedFromY
        //y coordinate cannot be less than 0
        newY = max(newY, 0)
        //y coordinate cannot be greater than height of color picker
        newY = min(newY, StrokeWidthSlider.strokeSliderHeight)
        return newY
    }
    
    static func calculateYCoordFromStrokeWidth (currentStrokeWidth : CGFloat) -> CGFloat {
        
        let yCoord = ((currentStrokeWidth - StrokeWidthSlider.strokeAmplification)/StrokeWidthSlider.strokeAmplification) * StrokeWidthSlider.strokeSliderHeight
        
        return yCoord
    }
    
    // MARK: vars for StrokeWidthSlider
    static private var strokeSliderHeight: CGFloat = 300
    static var minimumStrokeWidth: CGFloat = 15
    static var strokeAmplification: CGFloat = 15
    
}

//struct StrokeWidthSlider_Previews: PreviewProvider {
//    static var previews: some View {
//        StrokeWidthSlider()
//    }
//}
