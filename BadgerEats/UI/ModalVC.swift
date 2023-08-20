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
    var nutrFactsList: [String: String]
    var ingredientsList: String
    var containsList: [String]
        
    init(title: String, nutrFacts: [String: String], ingredients: String, contains: [String]) {
        print(nutrFacts)
        self.titleText = title
        self.nutrFactsList = nutrFacts
        self.ingredientsList = ingredients
        self.containsList = contains
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNutrFacts() -> String {
        var nutrFactsString = ""

        for (key, value) in self.nutrFactsList {
            if !nutrFactsString.isEmpty {
                nutrFactsString += ", "
            }
            nutrFactsString += "\(key): \(value)"
        }
        
        return nutrFactsString
    }
    
    func getContains() -> String {
        var containsString = ""
        for item in self.containsList {
            if item != "Vegetarian" && item != "Halal" && item != "Vegan" {
                containsString += item + ", "
            }
        }
        containsString = String(containsString.dropLast(2)) // Remove the last ", "
        return containsString
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
        modalPane.heightAnchor.constraint(equalTo: modalPane.widthAnchor, multiplier: 1.5, constant: 0).isActive = true

        // Add "Modal Content" label
        let modalLabel = UILabel()
        modalLabel.text = titleText.count > 20 ? "\(titleText.prefix(27))..." : titleText
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
        // Configure the button
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        closeButton.configuration = config
        modalPane.addSubview(closeButton)
        
        // Position the "Close" button
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.trailingAnchor.constraint(equalTo: modalPane.trailingAnchor, constant: -10).isActive = true
        closeButton.topAnchor.constraint(equalTo: modalPane.topAnchor, constant: 10).isActive = true
        closeButton.titleLabel?.topAnchor.constraint(equalTo: modalPane.topAnchor, constant: 10).isActive = true
        
        // Add contains label
        let containsLabel = UILabel()
        containsLabel.text = "Allergens"
        containsLabel.font = UIFont.boldSystemFont(ofSize: 15)
        modalPane.addSubview(containsLabel)
        
        containsLabel.translatesAutoresizingMaskIntoConstraints = false
        containsLabel.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        containsLabel.topAnchor.constraint(equalTo: modalLabel.bottomAnchor, constant: 20).isActive = true
        
        // Add contains label content
        let containsContent = UILabel()
        containsContent.text = getContains()
        containsContent.numberOfLines = 0
        containsContent.font = UIFont.systemFont(ofSize: 12)
        modalPane.addSubview(containsContent)
        
        // Position Nutrition Facts content
        containsContent.translatesAutoresizingMaskIntoConstraints = false
        containsContent.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        containsContent.trailingAnchor.constraint(equalTo: modalPane.trailingAnchor, constant: -10).isActive = true
        containsContent.topAnchor.constraint(equalTo: containsLabel.bottomAnchor, constant: 5).isActive = true
        
        
        // Add Nutrition Facts label
        let nutrLabel = UILabel()
        nutrLabel.text = "Nutrition Facts"
        nutrLabel.font = UIFont.boldSystemFont(ofSize: 15)
        modalPane.addSubview(nutrLabel)
        
        // Position Nutrition Facts Label
        nutrLabel.translatesAutoresizingMaskIntoConstraints = false
        nutrLabel.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        nutrLabel.topAnchor.constraint(equalTo: containsContent.bottomAnchor, constant: 20).isActive = true
        
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
        
        // Add Ingredients content within a scroll view
        let scrollView = UIScrollView()
        modalPane.addSubview(scrollView)
        
        // Scroll view constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: modalPane.trailingAnchor, constant: -5).isActive = true
        scrollView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 5).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: modalPane.bottomAnchor, constant: -10).isActive = true
        
        let ingredientsContent = UILabel()
        ingredientsContent.text = ingredientsList
        ingredientsContent.numberOfLines = 0
        ingredientsContent.font = UIFont.systemFont(ofSize: 12)
        scrollView.addSubview(ingredientsContent)
        
        ingredientsContent.translatesAutoresizingMaskIntoConstraints = false
        ingredientsContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        ingredientsContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        ingredientsContent.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        ingredientsContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        ingredientsContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10).isActive = true

        // Add tap gesture recognizer to the background view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func closeModal() {
        onClose?()
    }
}



