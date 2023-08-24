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
        let home = HomeVC()
        let settings = SettingsVC()
        let credits = CreditsVC()
        
        // Wrap each view controller in a UINavigationController and set titles
        let homeNavController = UINavigationController(rootViewController: home)
        let settingsNavController = UINavigationController(rootViewController: settings)
        let creditsNavController = UINavigationController(rootViewController: credits)
        
        homeNavController.title = "Menus"
        settingsNavController.title = "My Reviews"
        creditsNavController.title = "About"
        
        // Assign view controllers to the tab bar
        self.setViewControllers([homeNavController, settingsNavController, creditsNavController], animated: true)
        
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
