//
//  CustomMultiLineTextField.swift
//  Trial
//
//  Created by Janmajaya Mall on 20/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI
import UIKit

/**
 Multiline text field that expands its height as content increases. Width remains constant.
 
 If you want the multiline text field ot be firstReponder, then assign `isFirstResponder` as true.
 `textViewHeight` is binding for adjusting frame height of text field in swift ui
 */
struct CustomMultiLineTextField : UIViewRepresentable {
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        @Binding var textViewHeight: CGFloat
    
        
        init(text: Binding<String>, textViewHeight: Binding<CGFloat>) {
            _text = text
            _textViewHeight = textViewHeight
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            
            DispatchQueue.main.async {                
                self.text = textView.text
                self.textViewHeight = textView.contentSize.height
            }
        }
                
    }
    
    @Binding var text: String
    var isFirstResponder: Bool = false
    @Binding var textViewHeight: CGFloat
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.isScrollEnabled = true
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        if(self.isFirstResponder){
            uiView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> CustomMultiLineTextField.Coordinator {
        return CustomMultiLineTextField.Coordinator(text: self.$text, textViewHeight: self.$textViewHeight)
    }
    
    
}
// TODO: Remove textViewHeight if you are not using dynamic height
