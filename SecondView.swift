//
//  SecondView.swift
//  Trial
//
//  Created by Janmajaya Mall on 16/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct SecondView: View {
    
    @Binding var navigationState: Int?
    
    var body: some View {
        VStack(){
            Text("Second")
                
        }.background(Color.red)
        .onTapGesture(count: 2, perform: self.changet)
    }
    
    func changet() {        
        print("second", self.navigationState!)
        self.navigationState=2
        print("second end", self.navigationState!)
    }
}

//struct SecondView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecondView()
//    }
//}
