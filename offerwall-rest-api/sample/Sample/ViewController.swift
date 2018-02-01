//
//  ViewController.swift
//  Sample
//
//  Created by Tobias Schultka on 31.01.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let offerFactory = OfferFactory()
    let offerwallViewController = OfferwallViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestOfferwall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Request Annecy Media offerwall.
    func requestOfferwall() {
        offerFactory.getOffers(
            success: { offers in
                self.offerwallViewController.setOffers(offers: offers)
                self.present(self.offerwallViewController, animated: true, completion: nil)
            },
            visibilityChanged: { offers in
                self.offerwallViewController.setOffers(offers: offers)
            },
            failure: { error in }
        )
    }
}
