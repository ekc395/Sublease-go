//
//  Listing.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import Foundation

struct Listing: Identifiable, Hashable {
    let id: String
    var title: String
    var price: Int
    var bedrooms: Int
    var apartmentBuilding: String
    var furnished: Bool
    var description: String
    var genderPreference: String
    var leaseStart: Date
    var leaseEnd: Date
    var schoolYearPreference: String
    var userId: String
}

struct Filters: Hashable {
    var minBedrooms: Int? = nil
    var maxPrice: Int? = nil
    var furnishedOnly: Bool = false

    func apply(to listings: [Listing]) -> [Listing] {
        listings.filter { l in
            if let minBedrooms, l.bedrooms < minBedrooms {
                return false
            }
            if let maxPrice, l.price > maxPrice {
                return false
            }
            if furnishedOnly, l.furnished == false {
                return false
            }
            return true
        }
    }
}
