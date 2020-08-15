//
//  TrialMainNavigation.swift
//  Trial
//
//  Created by Janmajaya Mall on 23/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI


struct TrialMainNavigation: View {
    
    @State var circleDia: CGFloat = 50
    @State var moveDistance: CGFloat = 0
    
    var body: some View {
        GeometryReader{ geometryProxy in
            VStack{               
                    Circle().frame(width: self.circleDia, height: self.circleDia).foregroundColor(Color.green).offset(CGSize(width: (geometryProxy.size.width/2) - 50 , height: (geometryProxy.size.height/2) - 50 + self.moveDistance))
                        .gesture(DragGesture()
                        .onChanged({value in
                            print(value, "ad")
                            guard value.translation.height < 0 else {return}
                            self.moveDistance = value.translation.height
                        })
                        .onEnded({value in
                            
                        })
                ).animation(.spring())
            }.frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
        }
    }
}

struct TrialMainNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TrialMainNavigation()
    }
}
