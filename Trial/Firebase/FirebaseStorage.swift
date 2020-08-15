//
//  FirebaseStorage.swift
//  Trial
//
//  Created by Janmajaya Mall on 25/7/2020.
//  Copyright © 2020 Janmajaya Mall. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorage {
    
    static func uploadImageDataToStorage(withData imageData: Data, forUser userId: String, withCallback callbackClosure: @escaping (String, String) -> Void) {
        
        let storage = Storage.storage().reference()
        let imageUploadRef = storage.child("images/\(userId)+\(UUID().uuidString).jpeg")
        let imageMetadata = StorageMetadata()
        imageMetadata.contentType = "image/jpeg"
        
        _ = imageUploadRef.putData(imageData, metadata: imageMetadata) {(metadata, error) in
            
            if let error = error {
                print("Something went wrong  with error: \(error.localizedDescription)")
                return
            }                        
            
            imageUploadRef.downloadURL { (url, error) in
                if let error = error {
                    print("Something went wrong with error \(error.localizedDescription)")
                }
                
                guard let downloadUrl = url else {
                    print("Url is not present for the image")
                    return
                }
                
                callbackClosure(metadata?.name ?? "" ,downloadUrl.absoluteString)
            }
            
            return
            
        }
        
        
    }
    
}
