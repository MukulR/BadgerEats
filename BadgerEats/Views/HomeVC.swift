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
    
    var refreshContainer = UIRefreshControl()
    var tableView = UITableView()
    var menuItems: [MenuItem] = []
    
    var modalViewController: ModalViewController?
    var blurEffectView: UIVisualEffectView?
    
    var latest: UIView? = nil
    
    @objc func refreshData(send: UIRefreshControl) {
        print("Refreshed")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Call the fetchData function
        fetchData { menuItems, error in
            if let error = error {
                print("Error fetching data: \(error)")
            } else if let menuItems = menuItems {
                // Store the fetched menu items in a variable or update your UI
                print("Yes")
                self.menuItems = menuItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                // Call any method that updates your UI with the fetched data
//                self.updateUI(with: menuItems)
            }
        }
        
        refreshContainer.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        latest = configureHeaderStack()
        latest = configureSelect(button: selectHallButton, name: "Select Hall", options: ["Rheta's Market", "Gordon's Market", "Liz's Market"], padding: 20)
        latest = configureSelect(button: selectMealButton, name: "Select Meal", options: ["Breakfast", "Lunch", "Dinner"], padding: 5.0)
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
    
    func configureSelect(button: UIButton, name: String, options: Array<String>, padding: CGFloat) -> UIButton {
        view.addSubview(button)
        
        var actions = [UIAction]()
        
        for opt in options {
            actions.append(UIAction(title: opt, handler: { _ in
                button.setTitle(opt, for: .normal)
            }))
        }
        
        let hallSelect = UIMenu(children: actions)

        button.menu = hallSelect
        button.showsMenuAsPrimaryAction = true
        button.setTitle(name, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .tintColor
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let latestUnwrapped = latest {
            button.topAnchor.constraint(equalTo: latestUnwrapped.bottomAnchor, constant: padding).isActive = true
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        }
        
        return button
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
    
    @objc func showModal(title: String, nutrFacts: [String: String], ingredients: String) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.alpha = 0.5
        view.addSubview(blurEffectView!)

        modalViewController = ModalViewController(title: title, nutrFacts: nutrFacts, ingredients: ingredients)
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
        showModal(title: menuItem.title, nutrFacts: menuItem.nutritionData, ingredients: menuItem.ingredients)
    }
}

extension HomeVC {
    
    func fetchData(completion: @escaping ([MenuItem]?, Error?) -> Void) {
        guard let url = URL(string: "https://api.mukulrao.com/badgereats/getmenu/rheta/lunch/week") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
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
                           let ingredients = itemDict["ingredients"] as? String {
                            
                            let menuItem = MenuItem(title: title,
                                                    calories: calories,
                                                    icons: [],
                                                    rating: 0,
                                                    nutritionData: nutritionData,
                                                    ingredients: ingredients)
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



