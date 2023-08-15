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
        
        menuItems = fetchData()
        
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
    
    @objc func showModal(title: String) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.alpha = 0.5
        view.addSubview(blurEffectView!)

        modalViewController = ModalViewController(title: title)
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
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
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
        let menuItem = menuItems[indexPath.row]
        showModal(title: menuItem.title)
    }
}

extension HomeVC {
    
    func fetchData() -> [MenuItem] {
        let item1 = MenuItem(title: "Grilled Chicken Salad", calories: 200, icons: [], rating: 4.5,
                             nutritionData: ["Sodium": 250.0, "Protein": 25.0, "Carbohydrates": 10.0],
                             ingredients: ["Grilled chicken", "Mixed greens", "Tomatoes"])
        let item2 = MenuItem(title: "Margherita Pizza", calories: 300, icons: ["Vegetarian"], rating: 4.0,
                             nutritionData: ["Sodium": 400.0, "Protein": 15.0, "Carbohydrates": 35.0],
                             ingredients: ["Pizza dough", "Tomato sauce", "Fresh mozzarella"])
        let item3 = MenuItem(title: "Salmon Teriyaki", calories: 250, icons: [], rating: 4.2,
                             nutritionData: ["Sodium": 350.0, "Protein": 20.0, "Carbohydrates": 15.0],
                             ingredients: ["Salmon fillet", "Teriyaki sauce", "Steamed broccoli"])
        let item4 = MenuItem(title: "Vegetable Stir-Fry", calories: 180, icons: ["Vegan", "Gluten-Free"], rating: 4.1,
                             nutritionData: ["Sodium": 300.0, "Protein": 10.0, "Carbohydrates": 25.0],
                             ingredients: ["Mixed vegetables", "Tofu", "Stir-fry sauce"])
        let item5 = MenuItem(title: "Classic Cheeseburger", calories: 350, icons: [], rating: 4.3,
                             nutritionData: ["Sodium": 600.0, "Protein": 20.0, "Carbohydrates": 30.0],
                             ingredients: ["Beef patty", "Cheese", "Burger bun"])
        let item6 = MenuItem(title: "Pasta Primavera", calories: 280, icons: [], rating: 4.0,
                             nutritionData: ["Sodium": 320.0, "Protein": 12.0, "Carbohydrates": 40.0],
                             ingredients: ["Pasta", "Assorted vegetables", "Alfredo sauce"])
        let item7 = MenuItem(title: "Mango Chicken Curry", calories: 280, icons: [], rating: 4.2,
                             nutritionData: ["Sodium": 380.0, "Protein": 18.0, "Carbohydrates": 30.0],
                             ingredients: ["Chicken", "Mango", "Curry sauce"])
        let item8 = MenuItem(title: "Quinoa Salad", calories: 220, icons: [], rating: 4.4,
                             nutritionData: ["Sodium": 200.0, "Protein": 8.0, "Carbohydrates": 35.0],
                             ingredients: ["Quinoa", "Cucumber", "Feta cheese"])
        let item9 = MenuItem(title: "Beef Tacos", calories: 300, icons: [], rating: 4.1,
                             nutritionData: ["Sodium": 450.0, "Protein": 18.0, "Carbohydrates": 25.0],
                             ingredients: ["Beef", "Tortillas", "Salsa"])
        let item10 = MenuItem(title: "Veggie Omelette", calories: 220, icons: ["Gluten-Free"], rating: 4.3,
                              nutritionData: ["Sodium": 280.0, "Protein": 15.0, "Carbohydrates": 10.0],
                              ingredients: ["Eggs", "Bell peppers", "Spinach"])
        
        return [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10]
    }
}


