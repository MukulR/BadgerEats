//
//  MenuCell.swift
//  BadgerEats
//
//  Created by Mukul Rao on 8/6/23.
//

import UIKit

class MenuCell: UITableViewCell {
    
    var menuItemLabel = UILabel()
    var menuCalorieLabel = UILabel()
    var icons = UIStackView()
    var nutritionData: [String: CGFloat] = [:]
    var ingredients: String = ""
    
    var iconDict: [String: String] = ["Vegan": "leaf.fill", "Gluten-Free": "g.circle.fill", "Halal": "h.circle", "Vegetarian": "v.circle"]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(menuItemLabel)
        addSubview(menuCalorieLabel)
        addSubview(icons)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(menuItem: MenuItem) {
        menuItemLabel.text = menuItem.title.count > 27 ? "\(menuItem.title.prefix(27))..." : menuItem.title
//        titleText.count > 27 ? "\(titleText.prefix(27))..." : titleText
        
        menuCalorieLabel.text = String(menuItem.calories) + " Calories"
        
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
        
    }

    
    func configure() {
        menuItemLabel.numberOfLines = 0
        menuItemLabel.adjustsFontSizeToFitWidth = true
        menuItemLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        menuCalorieLabel.numberOfLines = 0
        menuCalorieLabel.adjustsFontSizeToFitWidth = true
        menuCalorieLabel.font = UIFont.systemFont(ofSize: 12)
        
        icons.axis = .horizontal
        icons.distribution = .fillEqually
        
        menuItemLabel.translatesAutoresizingMaskIntoConstraints = false
        menuItemLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        menuItemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        menuCalorieLabel.translatesAutoresizingMaskIntoConstraints = false
        menuCalorieLabel.topAnchor.constraint(equalTo: menuItemLabel.bottomAnchor, constant: 5).isActive = true
        menuCalorieLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        icons.translatesAutoresizingMaskIntoConstraints = false
        icons.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        icons.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        
        
    }


}
