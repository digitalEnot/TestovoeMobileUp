//
//  VkPhotoVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 13.08.2024.
//

import UIKit

class VkPhotoVC: UIViewController {
    let photoURL: String
    let photoDate: String
    let vkPhoto = UIImageView()

    
    init(photoURL: String, photoDate: String) {
        self.photoURL = photoURL
        self.photoDate = photoDate
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
        NetworkManager.shared.downloadVkPhoto(from: photoURL) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                self.vkPhoto.image = image
            }
        }
    }
    
    
    private func configureView() {
        self.navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .systemBackground
        navigationItem.title = photoDate
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
            
            shareSheetVC.completionWithItemsHandler = { activity, completed, items, error in
                if completed {
                    if activity == .saveToCameraRoll {
                        self.showSaveSuccessAlert()
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            present(shareSheetVC, animated: true)
        }
    }
    
    
    private func showSaveSuccessAlert() {
        let alertController = UIAlertController(title: "Сохранили!", message: "Эта фотография была сохранена в вашу галерею.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
