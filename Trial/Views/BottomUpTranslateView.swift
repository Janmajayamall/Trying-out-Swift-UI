//
//  BottomUpTranslateView.swift
//  Trial
//
//  Created by Janmajaya Mall on 9/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct BottomUpTranslateView <Content: View> : View {
    
    @Binding var isOpen: Bool
    var content: Content
    var parentSize: CGSize
    
    init(isOpen: Binding<Bool>, parentSize: CGSize,@ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.parentSize = parentSize
        self.content = content()
    }
    
    var body: some View {
        self.content
            .offset(CGSize(width: .zero, height: self.isOpen ? .zero : self.parentSize.height))
            .animation(.spring())
    }
}




//struct BottomUpTranslateView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomUpTranslateView()
//    }
//}
