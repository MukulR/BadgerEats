//
//  MenuCell.swift
//  BadgerEats
//
//  Created by Mukul Rao on 8/6/23.
//

import UIKit
import MarqueeLabel

class MenuCell: UITableViewCell {
    
    var menuItemLabel = MarqueeLabel()
    var ratingBar = UIView()
    var menuCalorieLabel = UILabel()
    var ratingLabel = UILabel()
    var icons = UIStackView()
    var nutritionData: [String: CGFloat] = [:]
    var ingredients: String = ""
    var rectangleWidthConstraint = NSLayoutConstraint()
    
    var menuItemLabelTrailingConstraint = NSLayoutConstraint()
    
    let LEFT_OFFEST = 20.0
    
    var iconDict: [String: String] = ["Vegan": "leaf.fill", "Gluten-Free": "g.circle.fill", "Halal": "h.circle", "Vegetarian": "v.circle", "Top 9 Free": "9.circle"]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(menuItemLabel)
        addSubview(menuCalorieLabel)
        addSubview(ratingLabel)
        addSubview(icons)
        configure()
        
        menuItemLabel.type = .continuous
        menuItemLabel.font = UIFont.boldSystemFont(ofSize: 15)
        menuItemLabel.animationCurve = .linear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(menuItem: MenuItem) {
        menuCalorieLabel.text = String(menuItem.calories) + " Calories"
        
        if menuItem.rating != -1.0 {
            ratingLabel.text = String(format: "%.1f", menuItem.rating)
            ratingBar.isHidden = false
            let widthMultiplier = (0.5 / 5.0) * menuItem.rating
            rectangleWidthConstraint.isActive = false
            rectangleWidthConstraint = ratingBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthMultiplier)
            rectangleWidthConstraint.isActive = true
        } else {
            ratingBar.isHidden = true
            ratingLabel.text = "Unrated"
            
            rectangleWidthConstraint.isActive = false
            rectangleWidthConstraint = ratingBar.trailingAnchor.constraint(equalTo: self.centerXAnchor)
            rectangleWidthConstraint.isActive = true
        }

        for subview in icons.arrangedSubviews {
            icons.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for icon in menuItem.contains {
            if let sysName = iconDict[icon] {
                let img = UIImage(systemName: sysName)
                
                let imageView = UIImageView()
                imageView.image = img
                imageView.contentMode = .scaleAspectFit
                icons.addArrangedSubview(imageView)
            }
        }
        
        var totalWidth: CGFloat = 0.0

        for subview in icons.arrangedSubviews {
            totalWidth += subview.intrinsicContentSize.width
        }

        // Add the spacing between subviews
        totalWidth += CGFloat(icons.arrangedSubviews.count - 1) * icons.spacing

        // If you want to consider the content insets of the stack view
        totalWidth += icons.layoutMargins.left + icons.layoutMargins.right
        
        
        menuItemLabelTrailingConstraint.isActive = false
        menuItemLabelTrailingConstraint = menuItemLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -totalWidth - LEFT_OFFEST)
        menuItemLabelTrailingConstraint.isActive = true
        menuItemLabel.text = menuItem.title + "   "
        menuItemLabel.labelize = false
        menuItemLabel.restartLabel()
//
        
    }

    
    func configure() {
        menuItemLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        menuCalorieLabel.numberOfLines = 0
        menuCalorieLabel.adjustsFontSizeToFitWidth = true
        menuCalorieLabel.font = UIFont.systemFont(ofSize: 12)
        
        icons.axis = .horizontal
        icons.distribution = .fillEqually
        
        menuItemLabel.translatesAutoresizingMaskIntoConstraints = false
        menuItemLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        menuItemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LEFT_OFFEST).isActive = true
        
        menuCalorieLabel.translatesAutoresizingMaskIntoConstraints = false
        menuCalorieLabel.topAnchor.constraint(equalTo: menuItemLabel.bottomAnchor, constant: 5).isActive = true
        menuCalorieLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LEFT_OFFEST).isActive = true
        
        icons.translatesAutoresizingMaskIntoConstraints = false
        icons.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        icons.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        
        // Add a rectangle view background
        let ratingBackgroundBar = UIView()
        ratingBackgroundBar.backgroundColor = .lightGray
        ratingBackgroundBar.layer.cornerRadius = 2.0
        self.addSubview(ratingBackgroundBar)
        
        // Position the rectangle background view
        ratingBackgroundBar.translatesAutoresizingMaskIntoConstraints = false
        ratingBackgroundBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        ratingBackgroundBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        ratingBackgroundBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
        let startPos = (self.frame.width / 4.0) + LEFT_OFFEST
        ratingBackgroundBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: startPos).isActive = true
        
        // Add main rectangle view
        ratingBar.backgroundColor = .tintColor
        ratingBar.layer.cornerRadius = 2.0
        self.addSubview(ratingBar)
        
        // Position the rectangle view.
        ratingBar.translatesAutoresizingMaskIntoConstraints = false
        ratingBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: startPos).isActive = true
        ratingBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        ratingBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        rectangleWidthConstraint = ratingBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: 0)
        rectangleWidthConstraint.isActive = true
        ratingBar.isHidden = true
        
        // Add rating label
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 15)
        ratingLabel.centerXAnchor.constraint(equalTo: ratingBar.trailingAnchor, constant: 0).isActive = true
        ratingLabel.bottomAnchor.constraint(equalTo: ratingBar.topAnchor, constant: -2).isActive = true
        
        let zeroLabel = UILabel()
        zeroLabel.font = UIFont.systemFont(ofSize: 10)
        zeroLabel.text = "0.0"
        self.addSubview(zeroLabel)
        
        zeroLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroLabel.centerYAnchor.constraint(equalTo: ratingBackgroundBar.centerYAnchor).isActive = true
        zeroLabel.trailingAnchor.constraint(equalTo: ratingBackgroundBar.leadingAnchor, constant: -3).isActive = true
        
        let fiveLabel = UILabel()
        fiveLabel.font = UIFont.systemFont(ofSize: 10)
        fiveLabel.text = "5.0"
        self.addSubview(fiveLabel)
        
        fiveLabel.translatesAutoresizingMaskIntoConstraints = false
        fiveLabel.centerYAnchor.constraint(equalTo: ratingBackgroundBar.centerYAnchor).isActive = true
        fiveLabel.leadingAnchor.constraint(equalTo: ratingBackgroundBar.trailingAnchor, constant: 3).isActive = true
        
    }


}
