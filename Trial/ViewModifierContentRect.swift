//
//  ViewModifierContentRect.swift
//  Trial
//
//  Created by Janmajaya Mall on 22/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct ViewModifierContentRect : ViewModifier {
    
    @Binding var contentRect: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(GetRect(rect: self.$contentRect))
    }
}

struct GetRect : View {
    
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader{ geometryProxy in
            self.createView(proxy:geometryProxy)
        }
        
    }
    
    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = proxy.frame(in: .global)
        }
        
        return Rectangle().fill(Color.clear)
    }
}


extension View {
    func getContentRect(contentRect: Binding<CGRect>) -> some View {
        ModifiedContent(content: self, modifier: ViewModifierContentRect(contentRect: contentRect))
    }
}
