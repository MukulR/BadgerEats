//
//  HomeVC.swift
//  BadgerEats
//
//  Created by Mukul Rao on 7/17/23.
//

import UIKit

class HomeVC: UIViewController {
    
    var headerStack = UIStackView()
    var selectHallButton = UIButton()
    
    var latest: UIView? = nil
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        latest = configureHeaderStack()
        
        let opts = [
        
            UIAction(title: "Rhetas") {
                action in
                print("Rheta")
            }
            
        ]
        
        latest = configureSelect(button: selectHallButton, name: "Select Hall", options: opts)
    }
    
    func configureHeaderStack() -> UIStackView {
        view.addSubview(headerStack)
        
        headerStack.axis = .horizontal
        headerStack.distribution = .equalSpacing
        
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        headerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        headerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let title = UILabel()
        title.text = "Menus"
        title.font = UIFont.boldSystemFont(ofSize: 30)
        
        let logo = UIImage(named: "wisc.png")
        
        let imageView = UIImageView()
        imageView.image = logo
        imageView.contentMode = .scaleAspectFill
        
        headerStack.addArrangedSubview(title)
        headerStack.addArrangedSubview(imageView)
        
        return headerStack
    }
    
    func configureSelect(button: UIButton, name: String, options: Array<UIAction>) -> UIButton {
        view.addSubview(button)
        
        let hallSelect = UIMenu(children: options)
        
        button.menu = hallSelect
        button.showsMenuAsPrimaryAction = true
        button.setTitle(name, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let latestUnwrapped = latest {
            button.topAnchor.constraint(equalTo: latestUnwrapped.bottomAnchor, constant: 20).isActive = true
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        }
        
        
        return button
    }

    
}
