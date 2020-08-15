//
//  ThirdView.swift
//  Trial
//
//  Created by Janmajaya Mall on 16/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct ThirdView: View {
    
    @Binding var navigationState: Int?
    
    var body: some View {
        VStack{
            Text("Third")
                .onTapGesture(count: 2, perform: self.changeIt)
        }
        
    }
    
    func changeIt() {
        print("third", self.navigationState!)
        self.navigationState=1
        print("third end", self.navigationState!)
    }
}

//struct ThirdView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThirdView()
//    }
//}
