//
//  VideoLabelView.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 13.08.2024.
//

import UIKit

final class VideoTitleView: UIView {
    let textLabel = UILabel()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 12
        addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(textLabel)
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.clipsToBounds = true
        blurEffectView.backgroundColor = .white.withAlphaComponent(0.5)
        blurEffectView.alpha = 0.7
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
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
