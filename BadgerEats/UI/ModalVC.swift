//
//  ModalVC.swift
//  BadgerEats
//
//  Created by Mukul Rao on 8/13/23.
//
import UIKit

class ModalViewController: UIViewController {

    var onClose: (() -> Void)?
    
    var titleText: String
    var nutrFactsList: [String: CGFloat]
    var ingredientsList: [String]
        
    init(title: String, nutrFacts: [String: CGFloat], ingredients: [String]) {
        self.titleText = title
        self.nutrFactsList = nutrFacts
        self.ingredientsList = ingredients
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNutrFacts() -> String {
        var nutrFactsString = ""

        for (key, value) in nutrFactsList {
            if !nutrFactsString.isEmpty {
                nutrFactsString += ", "
            }
            nutrFactsString += "\(key): \(value)"
        }
        
        return nutrFactsString
    }
    
    func getIngredients() -> String {
        return ingredientsList.joined(separator: ",")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Configure the modal pane
        let modalPane = UIView()
        modalPane.backgroundColor = .white
        modalPane.layer.cornerRadius = 10.0
        modalPane.layer.borderWidth = 1.0  // Add border width
        modalPane.layer.borderColor = view.tintColor.cgColor  // Add border color
        view.addSubview(modalPane)
        
        // Position the modal pane
        modalPane.translatesAutoresizingMaskIntoConstraints = false
        modalPane.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        modalPane.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        modalPane.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        modalPane.heightAnchor.constraint(equalTo: modalPane.widthAnchor).isActive = true

        // Add "Modal Content" label
        let modalLabel = UILabel()
        modalLabel.text = titleText
        modalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        modalPane.addSubview(modalLabel)
        
        // Position the "Modal Content" label
        modalLabel.translatesAutoresizingMaskIntoConstraints = false
        modalLabel.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        modalLabel.topAnchor.constraint(equalTo: modalPane.topAnchor, constant: 10).isActive = true

        // Add "Close" button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        modalPane.addSubview(closeButton)
        
        // Position the "Close" button
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.trailingAnchor.constraint(equalTo: modalPane.trailingAnchor, constant: -10).isActive = true
        closeButton.topAnchor.constraint(equalTo: modalPane.topAnchor, constant: 10).isActive = true
        
        // Add Nutrition Facts label
        let nutrLabel = UILabel()
        nutrLabel.text = "Nutrition Facts"
        nutrLabel.font = UIFont.boldSystemFont(ofSize: 15)
        modalPane.addSubview(nutrLabel)
        
        // Position Nutrition Facts Label
        nutrLabel.translatesAutoresizingMaskIntoConstraints = false
        nutrLabel.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        nutrLabel.topAnchor.constraint(equalTo: modalLabel.bottomAnchor, constant: 20).isActive = true
        
        // Add Nutrition Facts content
        let nutrFacts = UILabel()
        nutrFacts.text = getNutrFacts()
        nutrFacts.numberOfLines = 0
        nutrFacts.font = UIFont.systemFont(ofSize: 12)
        modalPane.addSubview(nutrFacts)
        
        // Position Nutrition Facts content
        nutrFacts.translatesAutoresizingMaskIntoConstraints = false
        nutrFacts.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        nutrFacts.trailingAnchor.constraint(equalTo: modalPane.trailingAnchor, constant: -10).isActive = true
        nutrFacts.topAnchor.constraint(equalTo: nutrLabel.bottomAnchor, constant: 5).isActive = true
        
        // Add Ingredients label
        let ingredientsLabel = UILabel()
        ingredientsLabel.text = "Ingredients"
        ingredientsLabel.font = UIFont.boldSystemFont(ofSize: 15)
        modalPane.addSubview(ingredientsLabel)
        
        // Position Ingredients Label
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        ingredientsLabel.topAnchor.constraint(equalTo: nutrFacts.bottomAnchor, constant: 20).isActive = true
        
        // Add Ingredients content
        let ingredientsContent = UILabel()
        ingredientsContent.text = getIngredients()
        ingredientsContent.numberOfLines = 0
        ingredientsContent.font = UIFont.systemFont(ofSize: 12)
        modalPane.addSubview(ingredientsContent)
        
        // Position Nutrition Facts content
        ingredientsContent.translatesAutoresizingMaskIntoConstraints = false
        ingredientsContent.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        ingredientsContent.trailingAnchor.constraint(equalTo: modalPane.trailingAnchor, constant: -10).isActive = true
        ingredientsContent.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 5).isActive = true
        
        // Add tap gesture recognizer to the background view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func closeModal() {
        onClose?()
    }
}


