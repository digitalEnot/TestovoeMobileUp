//
//  VkPhotoCell.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import UIKit

class VkPhotoCell: UICollectionViewCell {
    let cache = NetworkManager.shared.cache
    static let reuseID = "VkPhotoCell"
    let vkPhoto = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(photoURL: String) {
        NetworkManager.shared.downloadVkPhoto(from: photoURL) { [weak self] image in
            guard let self = self else {return}
            if let image {
                self.vkPhoto.image = image
            }
        }
    }
    
    
    private func configureUI() {
        contentView.addSubview(vkPhoto)
        vkPhoto.clipsToBounds = true
        vkPhoto.contentMode = .scaleAspectFill
        vkPhoto.translatesAutoresizingMaskIntoConstraints = false
            // TODO: разобраться насколько это важно
//        vkPhoto.frame = contentView.bounds

        NSLayoutConstraint.activate([
            vkPhoto.topAnchor.constraint(equalTo: topAnchor),
            vkPhoto.leadingAnchor.constraint(equalTo: leadingAnchor),
            vkPhoto.trailingAnchor.constraint(equalTo: trailingAnchor),
            vkPhoto.heightAnchor.constraint(equalTo: vkPhoto.widthAnchor),
        ])
    }
}
