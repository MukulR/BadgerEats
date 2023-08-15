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
        
    init(title: String) {
        self.titleText = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }

    @objc func closeModal() {
        onClose?()
    }
}


