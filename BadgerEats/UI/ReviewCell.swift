//
//  ReviewCell.swift
//  BadgerEats
//
//  Created by Mukul Rao on 8/23/23.
//

import UIKit
import MarqueeLabel

class ReviewCell: UITableViewCell {
    
    var menuItemLabel = MarqueeLabel(frame: CGRect(x: 20, y: 100, width: 200, height: 30), duration: 8, fadeLength: 10)
    var ratingBarWidthConstraint = NSLayoutConstraint()
    var ratingLabelXConstraint = NSLayoutConstraint()
    var ratingBar = UIView()
    var ratingLabel = UILabel()
    
    let LEFT_OFFEST = 20.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureRatingBar()
        
        menuItemLabel.type = .continuous
        menuItemLabel.font = UIFont.boldSystemFont(ofSize: 15)
        menuItemLabel.speed = .duration(20)
        menuItemLabel.animationCurve = .linear
        menuItemLabel.fadeLength = 10.0
        menuItemLabel.leadingBuffer = 14.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(reviewItem: ReviewItem) {
        print("Here")
        menuItemLabel.text = reviewItem.title
        
        menuItemLabel.labelize = false
        menuItemLabel.restartLabel()
        
        let widthMultiplier = (0.75 / 5.0) * reviewItem.rating
        ratingBarWidthConstraint.isActive = false
        ratingBarWidthConstraint = ratingBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthMultiplier)
        ratingBarWidthConstraint.isActive = true
        
        ratingLabel.text = String(format: "%.1f", reviewItem.rating)
        ratingLabelXConstraint.isActive = false
        ratingLabelXConstraint = ratingLabel.centerXAnchor.constraint(equalTo: ratingBar.trailingAnchor)
        ratingLabelXConstraint.isActive = true
    }
    
    func configure() {
        self.addSubview(menuItemLabel)
       
        menuItemLabel.translatesAutoresizingMaskIntoConstraints = false
        menuItemLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        menuItemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LEFT_OFFEST).isActive = true
        menuItemLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -LEFT_OFFEST).isActive = true
    }
    
    func configureRatingBar() {
        // Position the rectangle background view
        let ratingBackgroundBar = UIView()
        self.addSubview(ratingBackgroundBar)
        ratingBackgroundBar.backgroundColor = .lightGray
        ratingBackgroundBar.layer.cornerRadius = 2.0
        
        ratingBackgroundBar.translatesAutoresizingMaskIntoConstraints = false
        ratingBackgroundBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        ratingBackgroundBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        ratingBackgroundBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75, constant: 0).isActive = true
        ratingBackgroundBar.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: LEFT_OFFEST / 2).isActive = true
       
        
        // Add main rectangle view
        self.addSubview(ratingBar)
        ratingBar.backgroundColor = .tintColor
        ratingBar.layer.cornerRadius = 2.0
    
        // Position the rectangle view.
        ratingBar.translatesAutoresizingMaskIntoConstraints = false
        ratingBar.leadingAnchor.constraint(equalTo: ratingBackgroundBar.leadingAnchor, constant: 0).isActive = true
        ratingBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        ratingBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        ratingBarWidthConstraint = ratingBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75, constant: 0)
        ratingBarWidthConstraint.isActive = true
        
        // Add rating label
        self.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 15)
        ratingLabelXConstraint = ratingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ratingLabelXConstraint.isActive = true
        ratingLabel.bottomAnchor.constraint(equalTo: ratingBar.topAnchor, constant: -2).isActive = true
        
        let zeroLabel = UILabel()
        self.addSubview(zeroLabel)
        zeroLabel.font = UIFont.systemFont(ofSize: 10)
        zeroLabel.text = "0.0"
        self.addSubview(zeroLabel)
        
        zeroLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroLabel.centerYAnchor.constraint(equalTo: ratingBackgroundBar.centerYAnchor).isActive = true
        zeroLabel.trailingAnchor.constraint(equalTo: ratingBackgroundBar.leadingAnchor, constant: -3).isActive = true
        
        let fiveLabel = UILabel()
        self.addSubview(fiveLabel)
        fiveLabel.font = UIFont.systemFont(ofSize: 10)
        fiveLabel.text = "5.0"
        self.addSubview(fiveLabel)
        
        fiveLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveLabel.centerYAnchor.constraint(equalTo: ratingBackgroundBar.centerYAnchor).isActive = true
        fiveLabel.leadingAnchor.constraint(equalTo: ratingBackgroundBar.trailingAnchor, constant: 3).isActive = true
    }
    
}
