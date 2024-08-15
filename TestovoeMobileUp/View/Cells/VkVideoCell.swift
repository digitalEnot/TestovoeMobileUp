//
//  VkVideoCell.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import UIKit

final class VkVideoCell: UICollectionViewCell {
    static let reuseID = "VkVideoCell"
    private let vkVideoPrevPhoto = UIImageView()
    private let videoTitle = VideoTitleView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func set(vkVideoPrevPhoto: UIImage, videoTitle: String) {
        self.videoTitle.textLabel.text = videoTitle
        self.vkVideoPrevPhoto.image = vkVideoPrevPhoto
        self.videoTitle.isHidden = videoTitle.isEmpty
    }
    
    
    private func configureUI() {
        contentView.addSubview(vkVideoPrevPhoto)
        vkVideoPrevPhoto.image = UIImage(named: "video")
        vkVideoPrevPhoto.clipsToBounds = true
        vkVideoPrevPhoto.contentMode = .scaleAspectFill
        vkVideoPrevPhoto.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(videoTitle)
        videoTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vkVideoPrevPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            vkVideoPrevPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vkVideoPrevPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vkVideoPrevPhoto.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.55), // Для корректного отображения на iphone se 1-го поколения
            
            videoTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            videoTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            videoTitle.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: UIScreen.main.bounds.size.width == 320 ? 90 : 160), // Для корректного отображения на iphone se 1-го поколения
        ])
    }
}
