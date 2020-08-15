//
//  Publishers+Extensions.swift
//  Trial
//
//  Created by Janmajaya Mall on 12/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth

extension Publishers {
    
    //MARK: System wide publisher for keyboard height
    static var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter
                .default
                .publisher(for:UIResponder.keyboardWillShowNotification)
                .compactMap{
                    $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map({ $0.height }),
            NotificationCenter
                .default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map({ _ in CGFloat(0)})
        ).eraseToAnyPublisher()
    }
    
    static var didAuthStatusChangePublisher: AnyPublisher<User?, Never>{
        NotificationCenter
            .default
            .publisher(for: .didAuthStatusChange)
            .map { (notification) -> User? in
                if let auth = notification.object as? User {
                    return auth
                }
                return nil
            }
            .eraseToAnyPublisher()
    }

}
