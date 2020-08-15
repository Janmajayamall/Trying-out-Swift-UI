//
//  CustomKeyboard.swift
//  Trial
//
//  Created by Janmajaya Mall on 19/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI
import UIKit

struct CustomTextField : UIViewRepresentable {
    
    @Binding var text: String
    var firstResponder: Bool = false
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = self.text
        if(self.firstResponder==true){
            uiView.becomeFirstResponder()
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.textColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)        
        textField.delegate = context.coordinator
        return textField
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: self.$text)
    }
    
        
    class Coordinator : NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>){
            _text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }
        
    }
}
