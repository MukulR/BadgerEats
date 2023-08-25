//
//  ModalVC.swift
//  BadgerEats
//
//  Created by Mukul Rao on 8/13/23.
//
import UIKit

class ModalViewController: UIViewController {

    var onClose: (() -> Void)?
    
    var currentFoodID: Int
    
    var titleText: String
    var nutrFactsList: [String: String]
    var ingredientsList: String
    var containsList: [String]
    
    var modalPane = UIView()
    var ratingStepper = UIStepper()
    var ratingBar = UIView()
    var ratingLabel = UILabel()
    var rectangleWidthConstraint = NSLayoutConstraint()
    let baseMultiplier = 0.4
    var barCornerRadius = 2.0
    
    var notificationViewController: NotificationViewController?
        
    init(foodID: Int, title: String, nutrFacts: [String: String], ingredients: String, contains: [String]) {
        self.currentFoodID = foodID
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
    
    @objc func stepperValueChanged() {
        let stepperValue = ratingStepper.value
        let widthMultiplier = (baseMultiplier / ratingStepper.maximumValue) * stepperValue
        rectangleWidthConstraint.isActive = false
        rectangleWidthConstraint = ratingBar.widthAnchor.constraint(equalTo: modalPane.widthAnchor, multiplier: widthMultiplier)
        rectangleWidthConstraint.isActive = true
        ratingLabel.text = "\(Int(ratingStepper.value))/5"
    }
    
    func showNotification(titleContent: String, bodyContent: String) {
        notificationViewController = NotificationViewController(title: titleContent, content: bodyContent)
        notificationViewController?.view.isUserInteractionEnabled = false
        notificationViewController?.modalPresentationStyle = .overFullScreen
        notificationViewController?.modalTransitionStyle = .crossDissolve
        
        // Present the modal using a completion block to handle dismissal
        present(notificationViewController!, animated: true) { [weak self] in
            self?.notificationViewController?.onClose = {
                self?.notificationViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func postRating() {
        let urlString = "https://api.mukulrao.com/badgereats/addreview"
        let apiKey = ProcessInfo.processInfo.environment["API-KEY"] ?? "ERR"
       
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let foodID = self.currentFoodID
        let rating = self.ratingStepper.value
        
        // Prepare the JSON data
        let json: [String: Any] = ["deviceID": deviceID, "foodID": foodID, "foodName": self.titleText, "rating": rating]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Test", forHTTPHeaderField: "Test")
        request.setValue(apiKey, forHTTPHeaderField: "API-KEY")

        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.showNotification(titleContent: "Error", bodyContent: "An error occured while saving your rating.")
                }
            } else if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                if let data = data {
                    do {
                        if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if (responseJSON["status"] as! String == "success" && statusCode == 200) {
                                print("Successful rating")
                                let formattedFoodTitle = self.titleText.count > 20 ? "\(self.titleText.prefix(20))..." : self.titleText
                                DispatchQueue.main.async {
                                    self.showNotification(titleContent: "Saved Rating!", bodyContent: "You gave '\(formattedFoodTitle)' a rating of \(Int(self.ratingStepper.value))/5!")
                                }
                            }
                        } else {
                            print("Failed to parse JSON response.")
                        }
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            }
        }

        task.resume()

    }
    
    @objc func submitFoodRating() {
        postRating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the modal pane
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
        
        // Add rating label
        let rateLabel = UILabel()
        rateLabel.text = "Rate This Product"
        rateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        modalPane.addSubview(rateLabel)
        
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        rateLabel.topAnchor.constraint(equalTo: modalLabel.bottomAnchor, constant: 20).isActive = true
        
        // Add rate stepper
        ratingStepper.minimumValue = 0
        ratingStepper.maximumValue = 5
        ratingStepper.stepValue = 1
        ratingStepper.value = 5
        ratingStepper.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        ratingStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        modalPane.addSubview(ratingStepper)
        
        ratingStepper.translatesAutoresizingMaskIntoConstraints = false
        ratingStepper.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 0).isActive = true
        ratingStepper.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 5).isActive = true
        
        // Add rating label
        ratingLabel.text = "5/5"
        ratingLabel.font = UIFont.systemFont(ofSize: 12)
        modalPane.addSubview(ratingLabel)
        
        // Constrain rating label
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.leadingAnchor.constraint(equalTo: ratingStepper.trailingAnchor, constant: -5).isActive = true
        ratingLabel.centerYAnchor.constraint(equalTo: ratingStepper.centerYAnchor).isActive = true
        ratingLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        // Add a rectangle view background
        let ratingBackgroundBar = UIView()
        ratingBackgroundBar.backgroundColor = .lightGray
        ratingBackgroundBar.layer.cornerRadius = barCornerRadius
        modalPane.addSubview(ratingBackgroundBar)
        
        // Position the rectangle background view
        ratingBackgroundBar.translatesAutoresizingMaskIntoConstraints = false
        ratingBackgroundBar.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 3).isActive = true
        ratingBackgroundBar.centerYAnchor.constraint(equalTo: ratingStepper.centerYAnchor, constant: 0).isActive = true
        ratingBackgroundBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        ratingBackgroundBar.widthAnchor.constraint(equalTo: modalPane.widthAnchor, multiplier: baseMultiplier, constant: 0).isActive = true
        
        // Add main rectangle view
        ratingBar.backgroundColor = .tintColor
        ratingBar.layer.cornerRadius = barCornerRadius
        modalPane.addSubview(ratingBar)
        
        // Position the rectangle view
        ratingBar.translatesAutoresizingMaskIntoConstraints = false
        ratingBar.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 3).isActive = true
        ratingBar.centerYAnchor.constraint(equalTo: ratingStepper.centerYAnchor, constant: 0).isActive = true
        ratingBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        rectangleWidthConstraint = ratingBar.widthAnchor.constraint(equalTo: modalPane.widthAnchor, multiplier: baseMultiplier, constant: 0)
        rectangleWidthConstraint.isActive = true
        
        // Add background for submit button
        let background = UIView()
        background.backgroundColor = .tintColor
        background.layer.cornerRadius = 5.0
        modalPane.addSubview(background)
        
        // Constraint button background
        background.translatesAutoresizingMaskIntoConstraints = false
        background.centerYAnchor.constraint(equalTo: ratingStepper.centerYAnchor).isActive = true
        background.heightAnchor.constraint(equalTo: ratingStepper.heightAnchor, multiplier: 0.75).isActive = true
        background.trailingAnchor.constraint(equalTo: modalPane.trailingAnchor, constant: -10).isActive = true
        background.widthAnchor.constraint(equalTo: background.heightAnchor, multiplier: 3.0).isActive = true
        
        // Add submit rating button
        let submitRating = UIButton(type: .system)
        submitRating.setTitle("Submit", for: .normal)
        submitRating.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        submitRating.setTitleColor(.white, for: .normal)
        submitRating.addTarget(self, action: #selector(submitFoodRating), for: .touchUpInside)
        background.addSubview(submitRating)
        
        // Constrain submit rating button
        submitRating.translatesAutoresizingMaskIntoConstraints = false
        submitRating.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        submitRating.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        
        // Add contains label
        let containsLabel = UILabel()
        containsLabel.text = "Allergen Information"
        containsLabel.font = UIFont.boldSystemFont(ofSize: 15)
        modalPane.addSubview(containsLabel)
        
        containsLabel.translatesAutoresizingMaskIntoConstraints = false
        containsLabel.leadingAnchor.constraint(equalTo: modalPane.leadingAnchor, constant: 10).isActive = true
        containsLabel.topAnchor.constraint(equalTo: ratingStepper.bottomAnchor, constant: 20).isActive = true
        
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



