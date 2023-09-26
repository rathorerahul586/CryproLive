//
//  TabButton.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 21/09/23.
//

import UIKit

class TabButton: UIButton {
    
    private let bottomLineView = UIView()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                bottomLineView.backgroundColor = .systemRed
            } else {
                bottomLineView.backgroundColor = .clear
            }
        }
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
        // Add a bottom line view
        bottomLineView.backgroundColor = .clear // Initially, the line is clear
        addSubview(bottomLineView)
        // Create Auto Layout constraints for the bottom line
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 2.0) // Adjust the line height as needed
        ])
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}
