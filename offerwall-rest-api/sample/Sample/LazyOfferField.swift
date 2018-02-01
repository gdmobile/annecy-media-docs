//
//  LazyOfferField.swift
//  Sample
//
//  Created by Tobias Schultka on 01.02.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

class LazyOfferField {
    
    let key: String
    let value: String
    
    /// Create instance of lazy offer field.
    ///
    /// - Parameter json: Lazy offer field JSON.
    init(json: [String: Any]) {
        key = json["search"] as? String ?? ""
        value = json["replace"] as? String ?? ""
    }
}
