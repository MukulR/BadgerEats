//
//  CreditsVC.swift
//  BadgerEats
//
//  Created by Mukul Rao on 7/17/23.
//

import UIKit

class AboutVC: UIViewController {
    
    var headerStack = UIStackView()
    var refreshContainer = UIRefreshControl()
    var tableView = UITableView()
    var creditLabel = UILabel()
    
    
    var latest: UIView? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        view.addSubview(creditLabel)
        creditLabel.font = UIFont.systemFont(ofSize: 10)
        creditLabel.text = "Made by Mukul (mukul@cs.wisc.edu)"
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        creditLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        creditLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        // Set the title for the navigation bar
        latest = configureHeaderStack()
        latest = configureDietaryInfo()
        latest = configurePrivacy()
    
    }
    
    func configureHeaderStack() -> UIStackView {
        view.addSubview(headerStack)
        
        headerStack.axis = .horizontal
        headerStack.distribution = .equalSpacing
        
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20).isActive = true
        headerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        headerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let title = UILabel()
        title.text = "About Badger Eats"
        title.font = UIFont.boldSystemFont(ofSize: 30)
        
        let logo = UIImage(named: "wisc.png")
        
        let imageView = UIImageView()
        imageView.image = logo
        imageView.contentMode = .scaleAspectFill
        
        headerStack.addArrangedSubview(title)
        headerStack.addArrangedSubview(imageView)
        
        return headerStack
    }
    
    func getStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 5
        view.addSubview(stack)
        return stack
    }
    
    func getIcon(sysName: String) -> UIImageView {
        let img = UIImage(systemName: sysName)
        let imageView = UIImageView()
        imageView.image = img
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func getLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
//        label.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.width - 20).isActive = true
        return label
    }
    
    func configureDietaryInfo() -> UIStackView {
        let iconsTitle = UILabel()
        iconsTitle.text = "Icons"
        iconsTitle.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(iconsTitle)
        iconsTitle.translatesAutoresizingMaskIntoConstraints = false
        iconsTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        iconsTitle.topAnchor.constraint(equalTo: latest!.bottomAnchor, constant: 20).isActive = true
        
        // 4 icons total,
        // Vegan, Vegetarian, Halal, GF
        let veganStack = getStackView()
        let veganIcon = getIcon(sysName: "leaf.fill")
        let veganlabel = getLabel(text: "Vegan: No animal products")
        veganStack.addArrangedSubview(veganIcon)
        veganStack.addArrangedSubview(veganlabel)
        
        veganStack.translatesAutoresizingMaskIntoConstraints = false
        veganStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        veganStack.topAnchor.constraint(equalTo: iconsTitle.bottomAnchor, constant: 10).isActive = true
        veganStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // Vegetarian
        let vegStack = getStackView()
        let vegIcon = getIcon(sysName: "v.circle")
        let vegLabel = getLabel(text: "Vegetarian: No meat products")
        vegStack.addArrangedSubview(vegIcon)
        vegStack.addArrangedSubview(vegLabel)
        
        vegStack.translatesAutoresizingMaskIntoConstraints = false
        vegStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        vegStack.topAnchor.constraint(equalTo: veganStack.bottomAnchor, constant: 3).isActive = true
        vegStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // Halal
        let halalStack = getStackView()
        let halalIcon = getIcon(sysName: "h.circle")
        let halalLabel = getLabel(text: "Halal: Halal products")
        halalStack.addArrangedSubview(halalIcon)
        halalStack.addArrangedSubview(halalLabel)
        
        halalStack.translatesAutoresizingMaskIntoConstraints = false
        halalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        halalStack.topAnchor.constraint(equalTo: vegStack.bottomAnchor, constant: 3).isActive = true
        halalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // Gluten Free
        let gfStack = getStackView()
        let gfIcon = getIcon(sysName: "g.circle")
        let gfLabel = getLabel(text: "Gluten Free: No gluten products")
        gfStack.addArrangedSubview(gfIcon)
        gfStack.addArrangedSubview(gfLabel)
        
        gfStack.translatesAutoresizingMaskIntoConstraints = false
        gfStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        gfStack.topAnchor.constraint(equalTo: halalStack.bottomAnchor, constant: 3).isActive = true
        gfStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        
        // Other
        let top9Stack = getStackView()
        let top9Icon = getIcon(sysName: "9.circle")
        let top9Label = getLabel(text: "Top 9 Free: \"Top 9\" allergen free products")
        top9Stack.addArrangedSubview(top9Icon)
        top9Stack.addArrangedSubview(top9Label)
        
        top9Stack.translatesAutoresizingMaskIntoConstraints = false
        top9Stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        top9Stack.topAnchor.constraint(equalTo: gfStack.bottomAnchor, constant: 3).isActive = true
        top9Stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        return top9Stack
    }
    
    func configurePrivacy() -> UIScrollView {
        let privacyTitle = UILabel()
        view.addSubview(privacyTitle)
        privacyTitle.text = "Privacy"
        privacyTitle.font = UIFont.boldSystemFont(ofSize: 20)
        privacyTitle.translatesAutoresizingMaskIntoConstraints = false
        privacyTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        privacyTitle.topAnchor.constraint(equalTo: latest!.bottomAnchor, constant: 20).isActive = true
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        // Scroll view constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        scrollView.topAnchor.constraint(equalTo: privacyTitle.bottomAnchor, constant: 20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: creditLabel.topAnchor, constant: -10).isActive = true
   
    
        let attributedText = NSMutableAttributedString()

        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15)]
        let normalAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15)]

        let dataWeCollect = "Data We Collect:\n"
        attributedText.append(NSAttributedString(string: dataWeCollect, attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "• Device Vendor ID: Used to associate your product ratings to your device.\n", attributes: normalAttributes))
        attributedText.append(NSAttributedString(string: "• Ratings: The product ratings you provide, which are combined with ratings from other users to display the average ratings for food products.\n\n", attributes: normalAttributes))

        let howWeUseData = "How We Use Your Data:\n"
        attributedText.append(NSAttributedString(string: howWeUseData, attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "The data we collect is used solely for in-app purposes and is not shared to any third parties or examined.\n\n", attributes: normalAttributes))

        let dataStorage = "Data Storage:\n"
        attributedText.append(NSAttributedString(string: dataStorage, attributes: boldAttributes))
        attributedText.append(NSAttributedString(string: "Except for the Device Vendor ID and ratings you assign by choice, we do not store any other user data on our servers. If you don't provide ratings, none of your data is stored by us.", attributes: normalAttributes))

        let privacyContent = UILabel()
        privacyContent.attributedText = attributedText
        privacyContent.numberOfLines = 0
        scrollView.addSubview(privacyContent)
        privacyContent.translatesAutoresizingMaskIntoConstraints = false
        privacyContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        privacyContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        privacyContent.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        privacyContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        privacyContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10).isActive = true

        return scrollView
    }
    
}
