
//  Spots.swift


import Foundation
import Firebase

class Spots {
    var spotArray = [Spot]()
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    func loadData(completed: @escaping() -> ()){
        db.collection("spots").addSnapshotListener {(QuerySnapshot, error) in
        guard error == nil else {
            return completed()
        }
            self.spotArray = []
            //there are querySnapshot!.documents in the spots snapshot
            for document in QuerySnapshot!.documents {
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
        }
            completed()
        }
    }
}
