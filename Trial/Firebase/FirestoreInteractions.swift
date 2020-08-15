//
//  FirestoreInteractions.swift
//  Trial
//
//  Created by Janmajaya Mall on 26/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreInteractions {

    static func addNewPost(withPost post: PostModel) {
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("posts").addDocument(from: post)
        } catch let error {
            print(error, "addNewPost")
        }
        
        
    
    }
    
}

