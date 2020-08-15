//
//  CameraView.swift
//  Trial
//
//  Created by Janmajaya Mall on 28/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    
    @EnvironmentObject var screenManagement:MainScreenManagementViewModel
    @State var editingViewModel: EditingViewModel?
    
    @ViewBuilder
    var body: some View {
        
        if self.screenManagement.activeCameraScreen == .editing && self.editingViewModel != nil{
            AllView().environmentObject(self.editingViewModel!)
        }else{
            VStack{
                HStack{
                    Button(action: {
                        self.screenManagement.activeCameraScreen = .feed
                        self.screenManagement.activeMainScreen = .singleSwipeUp
                    }, label: {
                        Image(systemName: "xmark").imageScale(.large).padding(50)
                    })
                    Spacer()
                }
                Spacer()
                Button(action: {
                    self.editingViewModel = EditingViewModel(selectedImage: Image("ProfileImage"))
                    self.screenManagement.activeCameraScreen = .editing
                }, label: {
                    Circle().foregroundColor(.purple)
                        .frame(width: 60, height: 60)
                })
            }
        }
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
