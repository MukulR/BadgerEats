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
    var selectMealButton = UIButton()
    
    var selectedHall: String = "" {
        didSet {
            if selectedHall != oldValue {
                print("Selected Hall changed: \(selectedHall)")
                // Call the method to load data based on the new selectedHall
                loadData()
            }
        }
    }

    var selectedMeal: String = "" {
        didSet {
            if selectedMeal != oldValue {
                print("Selected Meal changed: \(selectedMeal)")
                // Call the method to load data based on the new selectedMeal
                loadData()
            }
        }
    }

    
    var refreshContainer = UIRefreshControl()
    var tableView = UITableView()
    var menuItems: [MenuItem] = []
    
    var modalViewController: ModalViewController?
    var blurEffectView: UIVisualEffectView?
    
    var latest: UIView? = nil
    
    func loadData() {
        if (self.selectedHall != "" && self.selectedMeal != "") {
            print("Start")
            
            let hallSlugs = ["Rheta's Market": "rhetas", "Gordon's Market": "gordons", "Liz's Market": "lizs", "Four Lakes Market": "fourlakes"]
            
            let market = hallSlugs[self.selectedHall] ?? ""
            let meal = self.selectedMeal.lowercased()
            
            if (market != "" && meal != "") {
                
                fetchData(market: market, meal: meal) { menuItems, error in
                    if let error = error {
                        print("Error fetching data: \(error)")
                    } else if let menuItems = menuItems {
                        self.menuItems = menuItems
                        DispatchQueue.main.async {
                            print("Reloading")
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    
    @objc func refreshData(send: UIRefreshControl) {
        print("Refreshed")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        refreshContainer.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        latest = configureHeaderStack()
        latest = configureSelects()
        latest = configureTableView()
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
    
    
    func handleSelection(hall: String, meal: String) {
        if (hall != "") {
            self.selectedHall = hall
        }
        
        if (meal != "") {
            self.selectedMeal = meal
        }
    }
    
    func configureSelects() -> UIButton {
        view.addSubview(selectHallButton)
        
        var hallActions = [UIAction]()
        let hallOptions = ["Four Lakes Market", "Gordon's Market", "Liz's Market", "Rheta's Market"]
        
        for opt in hallOptions {
            hallActions.append(UIAction(title: opt, handler: { _ in
                self.selectHallButton.setTitle(opt, for: .normal)
                self.handleSelection(hall: opt, meal: "");
            }))
        }
        
        let hallSelect = UIMenu(children: hallActions)

        selectHallButton.menu = hallSelect
        selectHallButton.showsMenuAsPrimaryAction = true
        selectHallButton.setTitle("Select Hall", for: .normal)
        selectHallButton.setTitleColor(.white, for: .normal)
        selectHallButton.backgroundColor = .tintColor
        selectHallButton.layer.cornerRadius = 8.0
        selectHallButton.translatesAutoresizingMaskIntoConstraints = false
        
        if let latestUnwrapped = latest {
            selectHallButton.topAnchor.constraint(equalTo: latestUnwrapped.bottomAnchor, constant: 20).isActive = true
            selectHallButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            selectHallButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        }
        

        // Repeat the process for selectMealButton
        view.addSubview(selectMealButton)
        
        var mealActions = [UIAction]()
        let mealOptions = ["Breakfast", "Lunch", "Dinner"]
        
        for opt in mealOptions {
            mealActions.append(UIAction(title: opt, handler: { _ in
                self.selectMealButton.setTitle(opt, for: .normal)
                self.handleSelection(hall: "", meal: opt);
            }))
        }
        
        let mealSelect = UIMenu(children: mealActions)

        selectMealButton.menu = mealSelect
        selectMealButton.showsMenuAsPrimaryAction = true
        selectMealButton.setTitle("Select Meal", for: .normal)
        selectMealButton.setTitleColor(.white, for: .normal)
        selectMealButton.backgroundColor = .tintColor
        selectMealButton.layer.cornerRadius = 8.0
        selectMealButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectMealButton.topAnchor.constraint(equalTo: selectHallButton.bottomAnchor, constant: 5.0).isActive = true
        selectMealButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        selectMealButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        return selectMealButton
    }

    
    func configureTableView() -> UITableView {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
       
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if let latestUnwrapped = latest {
            tableView.topAnchor.constraint(equalTo: latestUnwrapped.bottomAnchor, constant: 20).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }

        return tableView
    }
    
    @objc func showModal(foodID: Int, title: String, nutrFacts: [String: String], ingredients: String, contains: [String]) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.alpha = 0.5
        view.addSubview(blurEffectView!)

        modalViewController = ModalViewController(foodID: foodID, title: title, nutrFacts: nutrFacts, ingredients: ingredients, contains: contains)
        modalViewController?.modalPresentationStyle = .overFullScreen
        modalViewController?.modalTransitionStyle = .coverVertical

        // Present the modal using a completion block to handle dismissal
        present(modalViewController!, animated: true) { [weak self] in
            self?.modalViewController?.onClose = {
                self?.dismissModal()
            }
        }
    }

    func dismissModal() {
        blurEffectView?.removeFromSuperview()
        modalViewController?.dismiss(animated: true, completion: nil)
    }

    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        let menuItem = menuItems[indexPath.row]
        cell.set(menuItem: menuItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let menuItem = menuItems[indexPath.row]
        showModal(foodID: menuItem.foodID, title: menuItem.title, nutrFacts: menuItem.nutritionData, ingredients: menuItem.ingredients, contains: menuItem.contains)
    }
}

extension HomeVC {
    
    func fetchData(market: String, meal: String, completion: @escaping ([MenuItem]?, Error?) -> Void) {
        if (market == "") {
            completion(nil, NSError(domain: "Invalid Market", code: 0, userInfo: nil))
            return
        }
        
        guard let urlComponents = URLComponents(string: "https://api.mukulrao.com/badgereats/getmenu/\(market)/\(meal)") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        guard let url = urlComponents.url else {
           completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
           return
        }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let menuArray = json?["menu"] as? [[String: Any]] {
                    var menuItems: [MenuItem] = []
                    for itemDict in menuArray {
                        if let title = itemDict["name"] as? String,
                           let calories = itemDict["calories"] as? Int,
                           let nutritionData = itemDict["extraNutritionFacts"] as? [String: String],
                           let ingredients = itemDict["ingredients"] as? String,
                            let foodContains = itemDict["contains"] as? [String],
                            let foodID = itemDict["id"] as? Int {
                            let menuItem = MenuItem(foodID: foodID,
                                                    title: title,
                                                    calories: calories,
                                                    icons: [],
                                                    rating: 0,
                                                    nutritionData: nutritionData,
                                                    ingredients: ingredients,
                                                    contains: foodContains)
                            menuItems.append(menuItem)
                        }
                    }
                    completion(menuItems, nil)
                } else {
                    completion(nil, NSError(domain: "Invalid JSON format", code: 0, userInfo: nil))
                }
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}



