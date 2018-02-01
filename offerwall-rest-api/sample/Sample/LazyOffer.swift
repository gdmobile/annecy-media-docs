//
//  LazyOffer.swift
//  Sample
//
//  Created by Tobias Schultka on 01.02.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

import Foundation

class LazyOffer {
    
    let lazyId: String
    var fields: [LazyOfferField]
    
    /// Create instance of lazy offer.
    ///
    /// - Parameter json: Lazy offer JSON.
    init(json: [String: Any]) {
        lazyId = json["lazy_id"] as? String ?? ""
        fields = []
        
        if let fieldsJson = json["fields"] as? [[String: Any]] {
            for fieldJson in fieldsJson {
                fields.append(LazyOfferField(json: fieldJson))
            }
        }
    }
    
    /// Get desciption of a lazy offer.
    ///
    /// - returns: `String` desciption of a lazy offer.
    var description: String {
        return "[\n" +
            "  \"lazyId\": \(lazyId),\n" +
        "]"
    }
}
