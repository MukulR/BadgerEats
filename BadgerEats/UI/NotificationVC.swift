//
//  NotificationVC.swift
//  BadgerEats
//
//  Created by Mukul Rao on 8/22/23.
//

import UIKit

class NotificationViewController: UIViewController {
    
    var onClose: (() -> Void)?
    
    var titleText: String
    var contentText: String
    
    var notificationPane = UIView()
    var titleLabel = UILabel()
    var contentLabel = UILabel()
    
    var autoCloseTimer: Timer?
    
    init(title: String, content: String) {
        self.titleText = title
        self.contentText = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeModal() {
        autoCloseTimer?.invalidate()
        onClose?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        autoCloseTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(closeModal), userInfo: nil, repeats: false)
    }
    
    func configure() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeModal))
            notificationPane.addGestureRecognizer(tapGesture)
        
        // Configure the notification pane
        notificationPane.backgroundColor = .white
        notificationPane.layer.cornerRadius = 10.0
        notificationPane.layer.borderWidth = 1.0  // Add border width
        notificationPane.layer.borderColor = view.tintColor.cgColor  // Add border color
        view.addSubview(notificationPane)
        
        notificationPane.translatesAutoresizingMaskIntoConstraints = false
        notificationPane.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        notificationPane.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notificationPane.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        notificationPane.heightAnchor.constraint(equalTo: notificationPane.widthAnchor, multiplier: 0.15).isActive = true
        
        // Configure title label
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        notificationPane.addSubview(titleLabel)
        
        // Constrain title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: notificationPane.leadingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: notificationPane.topAnchor, constant: 5).isActive = true
        
        // Configure content label
        contentLabel.text = contentText
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        notificationPane.addSubview(contentLabel)
        
        // Constrain content label
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: notificationPane.leadingAnchor, constant: 10).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: notificationPane.bottomAnchor, constant: -7).isActive = true
        
    }
    
   
}
