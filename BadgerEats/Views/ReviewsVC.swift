//
//  SettingsVC.swift
//  BadgerEats
//
//  Created by Mukul Rao on 7/17/23.
//

import UIKit
import MarqueeLabel

class ReviewsVC: UIViewController {
    
    var headerStack = UIStackView()
    var refreshContainer = UIRefreshControl()
    var tableView = UITableView()
    
    var reviewItems: [ReviewItem] = []
    
    var latest: UIView? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        tableView.addSubview(refreshContainer)
        refreshContainer.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        // Set the title for the navigation bar
        latest = configureHeaderStack()
        latest = configureTableView()

        loadReviews()
    }
    
    @objc func refreshData(send: UIRefreshControl) {
        print("Refreshed")
        loadReviews()
        send.endRefreshing()
    }
    
    func loadReviews() {
        fetchData { reviewItems, error in
            if let error = error {
                print("Error fetching reviews: \(error)")
                return
            }
            
            if let reviewItems = reviewItems {
                // Process the received review items, e.g., update your UI
                DispatchQueue.main.async {
                    self.reviewItems = reviewItems
                    // Assuming you have a method to update UI with review items
                    self.tableView.reloadData()
                }
            }
        }
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
        title.text = "My Reviews"
        title.font = UIFont.boldSystemFont(ofSize: 30)
        
        let logo = UIImage(named: "wisc.png")
        
        let imageView = UIImageView()
        imageView.image = logo
        imageView.contentMode = .scaleAspectFill
        
        headerStack.addArrangedSubview(title)
        headerStack.addArrangedSubview(imageView)
        
        return headerStack
    }
    
    func configureTableView() -> UITableView {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
       
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if let latestUnwrapped = latest {
            tableView.topAnchor.constraint(equalTo: latestUnwrapped.bottomAnchor, constant: 20).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }

        return tableView
    }
}

extension ReviewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        let reviewItem = reviewItems[indexPath.row]
        cell.set(reviewItem: reviewItem)
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Loop through visible cells and stop label scrolling
        for case let cell as ReviewCell in tableView.visibleCells {
            cell.menuItemLabel.labelize = true
        }
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Loop through visible cells and start label scrolling
        for case let cell as ReviewCell in tableView.visibleCells {
            cell.menuItemLabel.labelize = false
        }
    }
    
}

extension ReviewsVC {
    
    func fetchData(completion: @escaping ([ReviewItem]?, Error?) -> Void) {
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
            completion(nil, NSError(domain: "DeviceIDError", code: -1, userInfo: nil))
            return
        }
        
        let urlString = "https://api.mukulrao.com/badgereats/getreviews/\(deviceID)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "URLError", code: -2, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "DataError", code: -3, userInfo: nil))
                return
            }
            
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [[Any]]],
                   let jsonArray = jsonDictionary["ratings"] {
                    
                    var reviewItems: [ReviewItem] = []
                    
                    for ratingInfo in jsonArray {
                        if ratingInfo.count >= 3,
                           let foodID = ratingInfo[0] as? String,
                           let name = ratingInfo[1] as? String,
                           let ratingString = ratingInfo[2] as? String,
                           let rating = Double(ratingString) {
                            
                            let reviewItem = ReviewItem(foodID: Int(foodID) ?? 0, title: name, rating: rating)
                            reviewItems.append(reviewItem)
                        }
                    }
                    
                    completion(reviewItems, nil)
                    
                } else {
                    print("Uh oh")
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
}

