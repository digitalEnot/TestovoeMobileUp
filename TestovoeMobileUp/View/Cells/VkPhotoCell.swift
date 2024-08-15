//
//  VkPhotoCell.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import UIKit

final class VkPhotoCell: UICollectionViewCell {
    static let reuseID = "VkPhotoCell"
    private let cache = NetworkManager.shared.cache
    private let vkPhoto = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(photo: UIImage) {
        self.vkPhoto.image = photo
    }
    
    
    private func configureUI() {
        contentView.addSubview(vkPhoto)
        vkPhoto.clipsToBounds = true
        vkPhoto.contentMode = .scaleAspectFill
        vkPhoto.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vkPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            vkPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vkPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vkPhoto.heightAnchor.constraint(equalTo: vkPhoto.widthAnchor)
        ])
    }
}
