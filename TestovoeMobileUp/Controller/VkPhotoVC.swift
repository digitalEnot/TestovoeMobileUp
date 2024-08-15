//
//  VkPhotoVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 13.08.2024.
//

import UIKit

final class VkPhotoVC: UIViewController {
    private let photoURL: String
    private let vkPhoto = UIImageView()

    
    init(photoURL: String) {
        self.photoURL = photoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhoto()
        configureView()
        configurePhoto()
    }
    
    
    private func setPhoto() {
        Task {
            do {
                let photo = try await NetworkManager.shared.downloadVkPhoto(from: photoURL)
                self.vkPhoto.image = photo
            } catch {
                present(Alerts.shared.defaultAlert(withError: error), animated: true)
            }
        }
    }
    
    
    private func configureView() {
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    
    private func configurePhoto() {
        view.addSubview(vkPhoto)
        vkPhoto.translatesAutoresizingMaskIntoConstraints = false
        vkPhoto.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            vkPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vkPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vkPhoto.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    @objc func shareButtonTapped() {
        if let image = vkPhoto.image {
            let shareSheetVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            shareSheetVC.completionWithItemsHandler = { [weak self] activity, completed, items, error in
                if completed {
                    if activity == .saveToCameraRoll {
                        self?.present(Alerts.shared.showPhotoAddedSuccessfully(), animated: true)
                    }
                }
                if let error = error {
                    self?.present(Alerts.shared.defaultAlert(withError: error), animated: true)
                }
            }
            present(shareSheetVC, animated: true)
        }
    }
}
