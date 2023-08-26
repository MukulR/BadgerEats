//
//  HomeVC.swift
//  BadgerEats
//
//  Created by Mukul Rao on 7/17/23.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate view controllers for different views
        let menus = HomeVC()
        let reviews = ReviewsVC()
        let about = AboutVC()
        
        menus.myReviewsVCReference = reviews
        
        // Wrap each view controller in a UINavigationController and set titles
        let menusNavController = UINavigationController(rootViewController: menus)
        let reviewsNavController = UINavigationController(rootViewController: reviews)
        let aboutNavController = UINavigationController(rootViewController: about)
        
        menusNavController.title = "Menus"
        reviewsNavController.title = "My Reviews"
        aboutNavController.title = "About"
        
        // Assign view controllers to the tab bar
        self.setViewControllers([menusNavController, reviewsNavController, aboutNavController], animated: true)
        
        // Set tab bar colors
        self.tabBar.tintColor = .tintColor
        
        // Set tab bar icons
        guard let items = self.tabBar.items else { return }
        let images = ["fork.knife", "newspaper", "info.circle"]
        for i in 0..<min(items.count, images.count) {
            items[i].image = UIImage(systemName: images[i])
        }
    }
}
