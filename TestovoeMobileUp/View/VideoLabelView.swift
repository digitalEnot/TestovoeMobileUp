//
//  VideoLabelView.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 13.08.2024.
//

import UIKit

class VideoLabelView: UIView {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = .white.withAlphaComponent(0.5)
        layer.cornerRadius = 16
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.numberOfLines = 2
        textLabel.textColor = .black
        
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

}
