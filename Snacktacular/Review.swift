//
//  Review.swift
//  Snacktacular
//
//  Created by Kim, Young-Tae on 4/14/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewingUserID: String
    var date: Date
    var documentID: String
    var dictionary:[String: Any] {
        return ["title": title, "text": text, "rating": rating, "reviewingUserID": reviewingUserID, "date": date, "documentID": documentID]
    }
    
    init(title: String, text: String, rating: Int, reviewingUserID: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewingUserID = reviewingUserID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let reviewingUserID = dictionary["reviewingUserID"] as! String? ?? ""
        let date = dictionary["date"] as! Date? ?? Date()
        self.init(title: title, text: text, rating: rating, reviewingUserID: reviewingUserID, date: date, documentID: "")
    }
    
    
    
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "UnknownUser"
        self.init(title: "", text: "", rating: 0, reviewingUserID: currentUserID, date: Date(), documentID: "")
    }
    
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("Error updating document")
                    completed(false)
                } else {
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil
            db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("Error creating new document")
                    completed(false)
                } else {
                    completed(true)
                }
            }
        }
    }
    
}
