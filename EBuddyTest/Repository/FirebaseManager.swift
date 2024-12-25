//
//  FirebaseManager.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//


import Foundation
import Combine
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    static let shared: FirebaseManager = FirebaseManager()

    func sendData(_ dataToSend: [String: Any], collectionName: String) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil

        ref = db.collection(collectionName).addDocument(data: dataToSend) { err in
            if let err  = err {
                print ("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }

    func getDataByCollection(collectionName: String, completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection(collectionName).getDocuments { (querySnapshot, err) in
            if let err = err {
                completion(nil, err)
            } else {
                if let documents = querySnapshot?.documents {
                    completion(documents, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }

    func getDataByQuery(_ collectionName: String, filters: [FilterModel], sortFilter: [SortModel], completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        let db = Firestore.firestore()
        var userRef: Query = db.collection(collectionName)

        for filter in filters {
            userRef = userRef.whereField(filter.filterName, isEqualTo: filter.filterValue!)
        }

        for sort in sortFilter {
            userRef = userRef.order(by: sort.sortBy, descending: sort.sortValue == .Desc)
        }
        
        userRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(nil, err)
            } else {
                if let documents = querySnapshot?.documents {
                    completion(documents, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
}
