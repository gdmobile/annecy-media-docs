//
//  OfferTableViewCell.swift
//  Sample
//
//  Created by Tobias Schultka on 01.02.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

import Foundation
import UIKit

class AMSDKOfferTableViewCell: UITableViewCell {
    
    fileprivate let TITLE_NUMBER_OF_LINES = 2
    fileprivate let MESSAGE_NUMBER_OF_LINES = 4
    fileprivate let MESSAGE_FONT_SIZE: CGFloat = 12
    fileprivate let THUMBNAIL_SIZE: CGFloat = 44
    fileprivate let THUMBNAIL_PADDING: CGFloat = 10
    fileprivate let CURRENCY_BUTTON_BACKGROUND_COLOR: UIColor = UIColor(red: 0.14, green: 0.76, blue: 0.45, alpha: 1.0)
    fileprivate let CURRENCY_BUTTON_CORNER_RADIUS: CGFloat = 5
    fileprivate let CURRENCY_BUTTON_BORDER_WIDTH: CGFloat = 0
    fileprivate let CURRENCY_BUTTON_BORDER_COLOR: UIColor = .clear
    fileprivate let CURRENCY_BUTTON_FONT: UIFont = UIFont.systemFont(ofSize: 14)
    
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let thumbnailContainer = UIView()
    let thumbnailImageView = UIImageView()
    let currencyContainer = UIView()
    let currencyButton = CurrencyButton()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // Add subviews
        contentView.addSubview(thumbnailContainer)
        thumbnailContainer.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(currencyContainer)
        currencyContainer.addSubview(currencyButton)
        
        // Enable autoresizing constraints
        thumbnailContainer.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyContainer.translatesAutoresizingMaskIntoConstraints = false
        currencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailContainer.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        thumbnailContainer.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        thumbnailContainer.leftAnchor.constraint(equalTo: marginGuide.leftAnchor).isActive = true
        thumbnailContainer.widthAnchor.constraint(equalToConstant: THUMBNAIL_SIZE + THUMBNAIL_PADDING).isActive = true
        
        thumbnailImageView.widthAnchor.constraint(equalToConstant: THUMBNAIL_SIZE).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: THUMBNAIL_SIZE).isActive = true
        thumbnailImageView.leftAnchor.constraint(equalTo: thumbnailContainer.leftAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: thumbnailContainer.centerYAnchor).isActive = true
        thumbnailImageView.alpha = 0
        
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: thumbnailContainer.rightAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor).isActive = true
        titleLabel.numberOfLines = TITLE_NUMBER_OF_LINES
        
        messageLabel.leftAnchor.constraint(equalTo: thumbnailContainer.rightAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: MESSAGE_FONT_SIZE * 0.4).isActive = true
        messageLabel.numberOfLines = MESSAGE_NUMBER_OF_LINES
        messageLabel.font = UIFont.systemFont(ofSize: MESSAGE_FONT_SIZE)
        messageLabel.textColor = UIColor.lightGray
        
        currencyContainer.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        currencyContainer.rightAnchor.constraint(equalTo: marginGuide.rightAnchor).isActive = true
        currencyContainer.leftAnchor.constraint(equalTo: messageLabel.rightAnchor).isActive = true
        currencyContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: MESSAGE_FONT_SIZE * 0.4).isActive = true
        currencyContainer.widthAnchor.constraint(equalToConstant: 80).isActive = true
        currencyContainer.heightAnchor.constraint(greaterThanOrEqualTo: currencyButton.heightAnchor).isActive = true
        
        currencyButton.rightAnchor.constraint(equalTo: currencyContainer.rightAnchor).isActive = true
        currencyButton.centerYAnchor.constraint(equalTo: currencyContainer.centerYAnchor).isActive = true
        currencyButton.widthAnchor.constraint(equalTo: currencyButton.widthAnchor)
        currencyButton.backgroundColor = CURRENCY_BUTTON_BACKGROUND_COLOR
        currencyButton.layer.cornerRadius = CURRENCY_BUTTON_CORNER_RADIUS
        currencyButton.layer.borderWidth = CURRENCY_BUTTON_BORDER_WIDTH
        currencyButton.layer.borderColor = CURRENCY_BUTTON_BORDER_COLOR.cgColor
        currencyButton.contentEdgeInsets.top = CURRENCY_BUTTON_FONT.pointSize * 0.4
        currencyButton.contentEdgeInsets.bottom = CURRENCY_BUTTON_FONT.pointSize * 0.4
        currencyButton.contentEdgeInsets.left = CURRENCY_BUTTON_FONT.pointSize * 0.8
        currencyButton.contentEdgeInsets.right = CURRENCY_BUTTON_FONT.pointSize * 0.8
    }
    
    /// Show thumbnail.
    ///
    /// - Parameter isFadingIn: Is thumbnail faiding in or not.
    func showThumbnail(isFadingIn: Bool) {
        if (isFadingIn) {
            thumbnailImageView.alpha = 0
            UIViewPropertyAnimator(duration: 0.5, curve: .easeIn, animations: {
                self.thumbnailImageView.alpha = 1
            }).startAnimation()
        } else {
            thumbnailImageView.alpha = 1
        }
    }
}
