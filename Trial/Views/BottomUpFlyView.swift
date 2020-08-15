//
//  BottomUpFlyView.swift
//  Trial
//
//  Created by Janmajaya Mall on 9/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct BottomUpFlyView <Content: View>: View {
    
    var content: Content
    var parentSize: CGSize
    
    init(parentSize: CGSize, @ViewBuilder content: () -> Content) {
        self.parentSize = parentSize
        self.content = content()
    }
    
    var body: some View {
        self.content
    }
}

//struct BottomUpFlyView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomUpFlyView>()
//    }
//}
//
