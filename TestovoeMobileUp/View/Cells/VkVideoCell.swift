//
//  VkVideoCell.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import UIKit

class VkVideoCell: UICollectionViewCell {
    static let reuseID = "VkVideoCell"
    var vkVideoPrevPhoto = UIImageView()
    var videoLabel = VideoLabelView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: не отобратьжать пустые описания
    func set(vkVideoPrevPhoto: String, videoLabel: String) {
        if videoLabel != "" {
            print("lol")
            self.videoLabel.textLabel.text = videoLabel
            configureLabel()
        } else {
            print("2")
        }
        
        NetworkManager.shared.downloadVkPhoto(from: vkVideoPrevPhoto) { [weak self] prevPhoto in
            guard let self else { return }
            DispatchQueue.main.async {
                self.vkVideoPrevPhoto.image = prevPhoto
            }
        }
    }
    
    
    private func configureLabel() {
        addSubview(videoLabel)
        videoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            videoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            videoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            videoLabel.widthAnchor.constraint(equalToConstant: 260)
        ])
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
