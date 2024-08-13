//
//  VkVideoCell.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import UIKit

class VkVideoCell: UICollectionViewCell {
    static let reuseID = "VkVideoCell"
    let vkVideoPrevPhoto = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        configureUI()
        backgroundColor = .systemBackground
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(vkVideoPrevPhoto: String) {
        
    }
    
    
    private func configureUI() {
        addSubview(vkVideoPrevPhoto)
        vkVideoPrevPhoto.image = UIImage(named: "video")
        vkVideoPrevPhoto.clipsToBounds = true
        vkVideoPrevPhoto.contentMode = .scaleAspectFill
        vkVideoPrevPhoto.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vkVideoPrevPhoto.topAnchor.constraint(equalTo: topAnchor),
            vkVideoPrevPhoto.leadingAnchor.constraint(equalTo: leadingAnchor),
            vkVideoPrevPhoto.trailingAnchor.constraint(equalTo: trailingAnchor),
            vkVideoPrevPhoto.heightAnchor.constraint(equalToConstant: 230),
        ])
    }
}
