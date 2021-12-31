//
//  StructTest.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 15/12/2021.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI



struct DocumentLoader {
    
    var storage: Storage!

    lazy var storageRef:StorageReference? = {
        return self.storage.reference().child("images")
    }()
    

    mutating func loadDocument() async throws -> Int {
       
        var sot = try await storageRef!.listAll().items.count
        
        if sot == 0 {
            throw fatalError("csdc")
        }
       
        return sot
    }
}
