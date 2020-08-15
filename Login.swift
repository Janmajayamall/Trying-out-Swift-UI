//
//  Login.swift
//  Trial
//
//  Created by Janmajaya Mall on 29/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import SwiftUI

struct Login: View {
    
    var window: UIWindow? = UIApplication.shared.windows.first ?? nil
    @Environment(\.presentationMode) var presentationMode
    @State var signInWithAppleCoordinator: SignInWithAppleCoordinator?
    
    var body: some View {
        VStack{
            HStack{
                Text("Create an accout or Sign In to continue.").font(Font.custom("Avenir", size: 30)).padding(.bottom, 10)
                Spacer()
            }.padding(10)
            Spacer()
            SignInWithApple().frame(width: 280, height: 45).onTapGesture {
                self.signInWithAppleCoordinator = SignInWithAppleCoordinator(window: self.window! )
                self.signInWithAppleCoordinator?.signIn(onSignedInHandler: {user in
                    print("Logged in with name \(String(describing: user.displayName)) & email \(String(describing: user.email))")
                    self.presentationMode.wrappedValue.dismiss()
                })
                
            }
            Spacer()
            HStack{
                Spacer()
                Text("By signing in you agree with you Terms and Conditions.").font(Font.custom("Avenir", size: 15))
                Spacer()
            }.padding(10)
        }.background(Color.white)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
