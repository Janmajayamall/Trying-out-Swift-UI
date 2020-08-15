//
//  ViewModifierKeyboardSafe.swift
//  Trial
//
//  Created by Janmajaya Mall on 20/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Combine
import SwiftUI

/**
 Viewmodifier to give bottom equivalent to the height of the keyboard
 */
struct ViewModifierPaddingKeyboardSafe : ViewModifier {
    @State var keyboardHeight: CGFloat = 0
    
    
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.keyboardHeight)
            .onReceive(Publishers.keyboardHeightPublisher, perform: {self.keyboardHeight=$0})
    }
}

/**
 Viewmodifier for reducing the frame height relative it its original for accomadting keyboard height.
 */
struct ViewModifierFrameKeyboardSafe : ViewModifier {
    @State var keyboardHeightRecv: CGFloat = 0
    @Binding var keyboardHeight: CGFloat
    var frameSize: CGSize
    var alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .frame(width: self.frameSize.width, height: self.frameSize.height - self.keyboardHeightRecv, alignment: self.alignment)
            .padding(.bottom, self.keyboardHeightRecv)
            .onReceive(Publishers.keyboardHeightPublisher, perform: {self.keyboardHeightRecv=$0; self.keyboardHeight=$0})
    }
}

/**
 Viewmodifier for avoiding expanding view frame height to go beyond keyabord height.
 */
struct ViewModifierExpandingHeightKeyboardAware : ViewModifier {
    @State var keyboardHeightRecv: CGFloat = 0
    @Binding var currentHeight: CGFloat
    var parentSize: CGSize
    var alreadyOccupiedHeight: CGFloat
    
    /**
     calculatedHeight determines the frame height of the view
     
     maximum height available for the view = self.parentSize.height-self.alreadyOccupiedHeight-self.keyboardHeightRecv
     Hence, calculatedHeight equals the currentHeight as long is currentHeight is smaller then maximum available height.
     Otherwise, calculatedHeight equals maximum available height
     */
    var calculatedHeight: CGFloat {
        if((self.parentSize.height-self.alreadyOccupiedHeight-self.keyboardHeightRecv)>self.currentHeight){
            return self.currentHeight
        }else{
            return self.parentSize.height-self.alreadyOccupiedHeight-self.keyboardHeightRecv
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: self.parentSize.width, height: self.calculatedHeight)
            .onReceive(Publishers.keyboardHeightPublisher, perform: {self.keyboardHeightRecv=$0})
    }
}

extension View {
    /**
     View modifier to give padding to the view for accomodating keyboard height
     */
    func keyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: ViewModifierPaddingKeyboardSafe())
    }
        
    
    /**
     Restricitng the frame height, relative to origincal frame height, for accomdating keybaord height. It also adds padding equiavelent to keyboard height cuasing its content to shift up by same magnitude.
     */
    func keyboardAwareFrame(frameSize: CGSize, alignment: Alignment, keyboardHeight: Binding<CGFloat> = Binding.constant(CGFloat(0))) -> some View {
        ModifiedContent(content: self, modifier: ViewModifierFrameKeyboardSafe(keyboardHeight: keyboardHeight, frameSize: frameSize, alignment: alignment))
    }
    
    /**
     View Modifier to restrict expanding height view to not strech beyond keyboard occipued view
     
     For example: Multiline text field is expands its height as its content increases, and in order to avoid it going beyond area occupied by keybord use this view modifier.
     
     - Parameters:
        - currentHeight: Current height of text field
        - parentSize: geometryProxy of parent view
        - alreadyOccupiedHeight: Height already occipued by other elements placed vertically.
     */
    func keyboardAwareExpandingHeightFrame(currentHeight: Binding<CGFloat>, parentSize:CGSize, alreadyOccupiedHeight: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: ViewModifierExpandingHeightKeyboardAware(currentHeight: currentHeight, parentSize: parentSize, alreadyOccupiedHeight: alreadyOccupiedHeight))
    }
}
