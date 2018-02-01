//
//  OfferFactory.swift
//  Sample
//
//  Created by Tobias Schultka on 01.02.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

//
//  AMSDKOfferFactory.swift
//  ios-sdk
//
//  Created by Tobias Schultka on 21.01.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

import Foundation
import AdSupport

class OfferFactory {
    private static let BASE_URL = "https://api.annecy.media"
    
    private let networkServive: NetworkService
    private var offerRequestCount: Int = 0
    private var requestId: String?
    
    /// Initialize Annecy offer factory.
    init() {
        self.networkServive = NetworkService()
    }
    
    /// Get offers.
    ///
    /// - Parameter success: Success completion handler.
    /// - Parameter visibilityChanged: Completion handler for lazy offers.
    /// - Parameter failure: Error completion handler.
    func getOffers(
        success: @escaping ([Offer]) -> Void,
        visibilityChanged: @escaping ([Offer]) -> Void,
        failure: @escaping (Error?) -> Void) {
        
        offerRequestCount += 1
        let previousOfferRequestCount = offerRequestCount
        let country: String = Locale.current.regionCode ?? ""
        let language: String = Locale.preferredLanguages.count == 0 ? "" : Locale.preferredLanguages[0]
        let idfa: String = ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? ASIdentifierManager.shared().advertisingIdentifier.uuidString : ""
        
        networkServive.request(
            url: "\(OfferFactory.BASE_URL)/offers",
            method: "GET",
            query: [
                "advertiser_id": idfa,
                "country": country,
                "locale": language,
                "platform": "ios",
                "user_id": "foo"
            ],
            success: { json in
                self.requestId = json["request_id"] as? String ?? nil
                var offers: [Offer] = []
                
                if let offersJson = json["offers"] as? [[String: Any]] {
                    for offerJson in offersJson {
                        offers.append(Offer(json: offerJson))
                    }
                }
                
                if let lazyUrls = json["lazy_calls"] as? [String] {
                    for lazyUrl in lazyUrls {
                        self.getLazyOffers(lazyUrl: lazyUrl, success: { lazyOffers in
                            
                            // Make sure, that user hasn't refreshed offers since last request.
                            if (self.offerRequestCount == previousOfferRequestCount) {
                                
                                // Replace tracking URL placeholders with fields from lazy offers.
                                for lazyOffer in lazyOffers {
                                    for offer in offers {
                                        if (offer.lazyId == lazyOffer.lazyId) {
                                            offer.updateTrackingUrl(lazyOffer: lazyOffer)
                                        }
                                    }
                                }
                                
                                visibilityChanged(offers)
                            }
                        })
                    }
                }
                
                success(offers)
        },
            failure: failure
        )
    }
    
    /// Get lazy offers.
    ///
    /// - Parameter lazyUrl: Lazy REST request URL.
    /// - Parameter success: Success completion handler.
    private func getLazyOffers(
        lazyUrl: String,
        success: @escaping ([LazyOffer]) -> Void) {
        
        networkServive.request(
            url: lazyUrl,
            method: "GET",
            query: nil,
            success: { json in
                var lazyOffers: [LazyOffer] = []
                
                if let lazyOffersJson = json["lazy_offers"] as? [[String: Any]] {
                    for lazyOfferJson in lazyOffersJson {
                        lazyOffers.append(LazyOffer(json: lazyOfferJson))
                    }
                }
                
                success(lazyOffers)
        }, failure: { error in
        })
    }
}
