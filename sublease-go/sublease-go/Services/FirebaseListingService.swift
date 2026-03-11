//
//  FirebaseListingService.swift
//  sublease-go
//
//  Created by Nathanael Simon on 3/5/26.
//

import Foundation
import FirebaseFirestore

final class FirebaseListingsService {
    private let db = Firestore.firestore()

    func fetchListings() async throws -> [Listing] {
        let snapshot = try await db.collection("listings").getDocuments()

        return snapshot.documents.compactMap { doc in
            let data = doc.data()

            guard
                let title = data["title"] as? String,
                let price = data["price"] as? Int,
                let bedrooms = data["bedrooms"] as? Int,
                let furnished = data["furnished"] as? Bool,
                let description = data["description"] as? String
            else {
                print("Missing or invalid required fields for listing \(doc.documentID)")
                return nil
            }

            let apartmentBuilding = data["apartmentBuilding"] as? String ?? "Seattle"
            let genderPreference = data["genderPreference"] as? String ?? "Any"
            let schoolYearPreference = data["schoolYearPreference"] as? String ?? "Any"
            let userId = data["userId"] as? String ?? ""
            let ownerName = data["ownerName"] as? String ?? userId
            let leaseStart = (data["leaseStart"] as? Timestamp)?.dateValue() ?? Date()
            let leaseEnd = (data["leaseEnd"] as? Timestamp)?.dateValue() ?? Date().addingTimeInterval(90 * 24 * 3600)

            return Listing(
                id: doc.documentID,
                title: title,
                price: price,
                bedrooms: bedrooms,
                apartmentBuilding: apartmentBuilding,
                furnished: furnished,
                description: description,
                genderPreference: genderPreference,
                leaseStart: leaseStart,
                leaseEnd: leaseEnd,
                schoolYearPreference: schoolYearPreference,
                userId: userId,
                ownerName: ownerName
            )
        }
    }

    func createListing(
        title: String,
        description: String,
        price: Int,
        bedrooms: Int,
        apartmentBuilding: String,
        furnished: Bool,
        genderPreference: String,
        schoolYearPreference: String,
        leaseStart: Date,
        leaseEnd: Date,
        userId: String,
        ownerName: String
    ) async throws -> String {
        let data: [String: Any] = [
            "title": title,
            "description": description,
            "price": price,
            "bedrooms": bedrooms,
            "apartmentBuilding": apartmentBuilding,
            "furnished": furnished,
            "genderPreference": genderPreference,
            "schoolYearPreference": schoolYearPreference,
            "leaseStart": Timestamp(date: leaseStart),
            "leaseEnd": Timestamp(date: leaseEnd),
            "userId": userId,
            "ownerName": ownerName
        ]

        let ref = try await db.collection("listings").addDocument(data: data)
        return ref.documentID
    }
    
    func deleteListing(id: String) async throws {
        try await db.collection("listings").document(id).delete()
    }
}
