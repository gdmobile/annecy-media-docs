//
//  Offer.swift
//  Sample
//
//  Created by Tobias Schultka on 01.02.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

import Foundation
import UIKit

public class Offer {
    
    enum CostType: String {
        case cpa = "cpa"
        case cpi = "cpi"
        case cps = "cps"
        case cpc = "cpc"
    }
    
    enum OfferType: String {
        case offer = "offer"
    }
    
    let costType: CostType?
    let credits: Int
    let ctaText: String?
    let ctaTitle: String?
    let id: String
    var image: UIImage?
    let imageUrlString: String
    let isLazy: Bool
    var isVisible: Bool
    let lazyId: String?
    let message: String
    let title: String
    var trackingUrl: String
    let type: OfferType?
    
    /// Create instance of offer.
    ///
    /// - Parameter json: Offer JSON.
    init(json: [String: Any]) {
        costType = CostType(rawValue: (json["cost_type"] as? String) ?? "")
        credits = json["credits"] as? Int ?? 0
        ctaText = json["cta_text"] as? String == "" ? nil : json["cta_text"] as? String ?? nil
        ctaTitle = json["cta_title"] as? String == "" ? nil : json["cta_title"] as? String ?? nil
        id = json["id"] as? String ?? ""
        imageUrlString = json["image_url"] as? String ?? ""
        isLazy = json["lazy"] as? Bool ?? false
        isVisible = !isLazy
        lazyId = json["lazy_id"] as? String == "" ? nil : json["lazy_id"] as? String ?? nil
        message = json["text"] as? String ?? ""
        title = json["title"] as? String ?? ""
        trackingUrl = json["tracking_url"] as? String ?? ""
        type = OfferType(rawValue: (json["type"] as? String) ?? "")
    }
    
    /// Get image.
    ///
    /// - Parameter success: Success completion handler.
    func getImage(success: @escaping (UIImage, Bool) -> Void) {
        if let image = self.image {
            success(image, false)
            return
        }
        
        guard let url = URL(string: imageUrlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            if let newImage = UIImage(data: data) {
                DispatchQueue.main.sync() {
                    self.image = newImage
                    success(newImage, true)
                }
            }
        }
        
        task.resume()
    }
    
    /// Replace placeholder keys in tracking URL with fields from lazy offers.
    /// Make offer visible.
    ///
    /// - Parameter lazyOffer: Lazy offer.
    func updateTrackingUrl(lazyOffer: LazyOffer) {
        for field in lazyOffer.fields {
            trackingUrl = trackingUrl.replacingOccurrences(of: field.key, with: field.value);
        }
        
        isVisible = true
    }
    
    /// Get desciption of an offer.
    ///
    /// - returns: `String` desciption of an offer.
    var description: String {
        return "[\n" +
            "  \"costType\": \(costType?.rawValue ?? "nil"),\n" +
            "  \"credits\": \(credits),\n" +
            "  \"ctaText\": \(ctaText ?? "nil"),\n" +
            "  \"ctaTitle\": \(ctaTitle ?? "nil"),\n" +
            "  \"id\": \(id),\n" +
            "  \"imageUrlString\": \(imageUrlString),\n" +
            "  \"isLazy\": \(isLazy),\n" +
            "  \"isVisible\": \(isVisible),\n" +
            "  \"lazyId\": \(lazyId ?? "nil"),\n" +
            "  \"message\": \(message),\n" +
            "  \"title\": \(title),\n" +
            "  \"trackingUrl\": \(trackingUrl),\n" +
            "  \"type\": \(type?.rawValue ?? "nil"),\n" +
        "]"
    }
}
