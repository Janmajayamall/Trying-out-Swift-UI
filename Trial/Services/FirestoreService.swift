//
//  FirestoreService.swift
//  Trial
//
//  Created by Janmajaya Mall on 5/8/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol FirestoreServiceDelegate: class {
    func firestorePostsUpdated(_ posts: Array<PostModel>)
}


class FirestoreService {
    
    private var documentsListener: ListenerRegistration?
    private var postCollectionRef: CollectionReference = Firestore.firestore().collection("posts")
    weak var delegate: FirestoreServiceDelegate?
    
    func listenToPosts(forAreaGeohashes geohashes: Array<String>){
        
        self.stopListeningToPosts()
        
        var posts: Array<PostModel> = []
        
        self.documentsListener = self.postCollectionRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {return}
            documents.forEach { (queryDocumentSnapshot) in
                guard let post = try? queryDocumentSnapshot.data(as: PostModel.self) else {
                    print("something went wrong")
                    return
                }
                posts.append(post)
            }
        }
        
        delegate?.firestorePostsUpdated(posts)
    }
    
    func stopListeningToPosts(){
        if let documentsListener = self.documentsListener {
            documentsListener.remove()
        }
    }
    
}
