//
//  UIAutoScrollLabel.swift
//  BadgerEats
//
//  Created by Mukul Rao on 8/24/23.
//

import UIKit

class UIAutoScrollLabel: UIView {
    
    private let scrollView = UIScrollView()
    private let label = UILabel()
    
    private var isScrolling = false
    private var animationTimer: Timer?
    
    var text: String = "" {
        didSet {
            label.text = text
            label.sizeToFit() // Adjust label's frame size to fit the new text
            
            if !isScrolling {
                startScrolling()
            }
        }
    }
    
    var scrollSpeed: CGFloat = 50.0 {
        didSet {
            if isScrolling {
                stopScrolling() // Stop the ongoing animation before adjusting speed
                startScrolling()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: label.frame.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        scrollView.addSubview(label)
        scrollView.frame = bounds
        scrollView.contentSize = label.intrinsicContentSize
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        
        addSubview(scrollView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func setScrollViewConstraints(leadingAnchor: NSLayoutXAxisAnchor, topAnchor: NSLayoutYAxisAnchor, widthAnchor: NSLayoutDimension) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func startScrolling() {
        isScrolling = true
        print("ST")
        print(label.frame.width)
        
        animationTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(label.frame.width / scrollSpeed),
            target: self,
            selector: #selector(animateScroll),
            userInfo: nil,
            repeats: true
        )
        animationTimer?.fire()
    }
    
    @objc private func animateScroll() {
        scrollView.contentOffset.x += 1
        
        if scrollView.contentOffset.x >= label.frame.width {
            scrollView.contentOffset.x = 0
        }
    }
    
    private func stopScrolling() {
        print("STOP")
        animationTimer?.invalidate()
        animationTimer = nil
        scrollView.contentOffset.x = 0
        isScrolling = false
    }
}
