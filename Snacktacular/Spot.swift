
//  Spot.swift


import Foundation
import CoreLocation
import Firebase

class Spot{
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    var dictionary: [String: Any]{
        return ["name": name, "address": address, "longitude": longitude, "latitude": latitude,
                "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID]
    }
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init(){
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    func saveData(completed: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        //grab userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            return completed(false)
        }
        self.postingUserID = postingUserID
        //create dict representing data
        let dataToSave = self.dictionary
        //if we have saved a record, we'll have a doc ID
        if self.documentID != "" {
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("Error updating \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("Error creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("New doc created with ref ID \(ref?.documentID ?? "unkonwn")")
                    completed(true)
                }
            }
        }
    }
}

