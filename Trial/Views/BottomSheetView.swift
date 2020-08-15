//
//  BottomSheetView.swift
//  Trial
//
//  Created by Janmajaya Mall on 6/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct BottomSheetView <Content: View>: View {
    
    @Binding var isOpen: Bool
    var content: Content
    var parentSize: CGSize
    var viewHeight: CGFloat {
        return self.parentSize.height * self.viewHeightRatio
    }
    
    init(isOpen: Binding<Bool>, parentSize: CGSize, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.parentSize = parentSize
        self.content = content()
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    self.isOpen = false
                },label: {
                    Image(systemName: "xmark").font(Font.system(size: 15, weight: .bold)).foregroundColor(Color.primaryColor)
                }).padding(15)
            }
            self.content
        }.frame(width: self.parentSize.width, height: self.viewHeightRatio * self.parentSize.height, alignment: .top)
            .background(Color.white)
            .cornerRadius(12)
            .offset(CGSize(width: .zero, height: self.isOpen ? self.parentSize.height - self.viewHeight : self.parentSize.height))
            .animation(.spring())
    }
    
    private let viewHeightRatio: CGFloat = 0.6
}
//
//struct BottomSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomSheetView()
//    }
//}
