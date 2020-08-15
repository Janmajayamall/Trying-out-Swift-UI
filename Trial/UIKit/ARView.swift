//
//  ARView.swift
//  Trial
//
//  Created by Janmajaya Mall on 6/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct ARView: UIViewRepresentable {
    
    var parentSize: CGSize
    
    func makeUIView(context: Context) -> ARSceneUIView {
        let view = ARSceneUIView(parentSize: self.parentSize)
        
        view.startSession()
        
        return view
    }
    
    func updateUIView(_ uiView: ARSceneUIView, context: Context) {
        
    }

    
}
