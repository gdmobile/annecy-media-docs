//
//  OfferwallViewController.swift
//  Sample
//
//  Created by Tobias Schultka on 01.02.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

import Foundation
import UIKit

class OfferwallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var offers: [Offer]?
    fileprivate let offersTableView: UITableView = UITableView()
    
    fileprivate let CURRENCY_BUTTON_COLOR: UIColor = .white
    fileprivate let CURRENCY_BUTTON_FONT: UIFont = UIFont.systemFont(ofSize: 14)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        offersTableView.dataSource = self
        offersTableView.delegate = self
        
        self.view.addSubview(offersTableView)
        offersTableView.translatesAutoresizingMaskIntoConstraints = false
        offersTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        offersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        offersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        offersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.view.backgroundColor = UIColor.gray
        self.modalTransitionStyle = .coverVertical
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    /// Set offers to offerwall.
    ///
    /// - Parameter offers: Array of offers.
    func setOffers(offers: [Offer]) {
        self.offers = offers.filter{$0.isVisible}
        DispatchQueue.main.async {
            self.offersTableView.reloadData()
        }
    }
    
    /// Open offer.
    ///
    /// - Parameter urlString: Tracking URL.
    func openOffer(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /// On pressed offer.
    ///
    /// - Parameter urlString: Tracking URL.
    @objc
    func onPressedCurrencyButton(_ sender: AnyObject) {
        if let currencyButton = sender as? CurrencyButton {
            if let urlString = currencyButton.offer?.trackingUrl {
                openOffer(urlString: urlString)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = offers?[indexPath.row].id ?? ""
        let cell = AMSDKOfferTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: id)
        guard let offer = offers?[indexPath.row] else { return cell }
        
        cell.titleLabel.text = offer.title
        cell.messageLabel.text = offer.message
        if (offer.credits > 0) {
            cell.currencyButton.setTitle("+\(offer.credits)", for: .normal)
            cell.currencyButton.setTitleColor(CURRENCY_BUTTON_COLOR, for: .normal)
            cell.currencyButton.titleLabel?.font = CURRENCY_BUTTON_FONT
            cell.currencyButton.isHidden = false
            cell.currencyButton.offer = offer
            cell.currencyButton.addTarget(self, action: #selector(onPressedCurrencyButton(_:)), for: .touchUpInside)
        } else {
            cell.currencyButton.isHidden = true
        }
        
        offer.getImage(success: { image, isFadingIn in
            cell.thumbnailImageView.image = image
            cell.showThumbnail(isFadingIn: isFadingIn)
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = offers?[indexPath.row].trackingUrl {
            openOffer(urlString: urlString)
        }
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {return .fullScreen}
        set {}
    }
}
