//
//  MainVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 09.08.2024.
//

import UIKit

class MainVC: UIViewController {
    
    var accessToken: String
    let segment = UISegmentedControl(items: ["Фото", "Видео"])
    var vkPhotoCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var vkVideoCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var photos: [Photo] = []
    var images: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureElements()
        configureNavItems()
        configureCollectionView()
        network()
    }
    
    init(accessToken: String) {
        self.accessToken = accessToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func network() {
        NetworkManager.shared.getFriends(accessToken: accessToken) { [weak self] photos in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.photos = photos
                self.vkPhotoCollectionView.reloadData()
            }
        }
    }

    
    private func configureNavItems() {
        title = " MobileUP Gallery"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход", style: .done, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.hidesBackButton = true
    }
    
    private func configureElements() {
        view.addSubview(segment)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureCollectionView() {
        vkPhotoCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoSquareColumnLayout(in: view))
        vkVideoCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createOneRectangleColumnLayout(in: view))
        view.addSubview(vkPhotoCollectionView)
        view.addSubview(vkVideoCollectionView)
        vkVideoCollectionView.isHidden = true
        NSLayoutConstraint.activate([
            vkPhotoCollectionView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 8),
            vkPhotoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vkPhotoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vkPhotoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vkVideoCollectionView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 8),
            vkVideoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vkVideoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vkVideoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        vkPhotoCollectionView.delegate = self
        vkPhotoCollectionView.dataSource = self
        vkPhotoCollectionView.backgroundColor = .systemBackground
        vkPhotoCollectionView.register(VkPhotoCell.self, forCellWithReuseIdentifier: VkPhotoCell.reuseID)
        vkPhotoCollectionView.translatesAutoresizingMaskIntoConstraints = false

        vkVideoCollectionView.delegate = self
        vkVideoCollectionView.dataSource = self
        vkVideoCollectionView.backgroundColor = .systemBackground
        vkVideoCollectionView.register(VkVideoCell.self, forCellWithReuseIdentifier: VkVideoCell.reuseID)
        vkVideoCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func logOut() {
        print("you logged out")
        do {
           try PersistanceManager.updateWith(accessToken: "", actionType: .remove)
        } catch {
            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            vkVideoCollectionView.isHidden = true
            vkPhotoCollectionView.isHidden = false
        case 1:
            vkVideoCollectionView.isHidden = false
            vkPhotoCollectionView.isHidden = true
        default:
            return
        }
    }
}


extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == vkPhotoCollectionView {
            photos.count
        } else {
            5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == vkPhotoCollectionView {
            if let imageURL = photos[indexPath.row].sizes.first(where: { $0.type == .x }) {
                let imageURL = imageURL.url
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VkPhotoCell.reuseID, for: indexPath) as! VkPhotoCell
                cell.set(photoURL: imageURL)
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VkVideoCell.reuseID, for: indexPath) as! VkVideoCell
            return cell
        }
    }
}
