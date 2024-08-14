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
        backgroundColor = .clear
        layer.cornerRadius = 12
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.contentView.addSubview(textLabel)
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.clipsToBounds = true
        blurEffectView.backgroundColor = .clear
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.numberOfLines = 2
        textLabel.textColor = .black
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: -4),
            
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
