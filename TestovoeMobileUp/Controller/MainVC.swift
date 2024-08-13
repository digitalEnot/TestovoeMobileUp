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
    var videos: [Video] = []
    
    var photosOnTheScreen: [Photo] = []
    var hasMorePhotos = true
    
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
        NetworkManager.shared.getPhotos(accessToken: accessToken) { [weak self] photos in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.photos = photos
                self.addPhotosToTheScreen()
            }
        }
    }
    
    private func addPhotosToTheScreen() {
        if photosOnTheScreen.count < photos.count {
            hasMorePhotos = true
            let minEl = photosOnTheScreen.count
            if photos.count - minEl >= 30 {
                photosOnTheScreen.append(contentsOf: photos[minEl..<minEl + 30])
            } else {
                photosOnTheScreen.append(contentsOf: photos[minEl...])
            }
            vkPhotoCollectionView.reloadData()
        } else {
            hasMorePhotos = false
        }
    }

    
    private func configureNavItems() {
        title = " MobileUP Gallery"
        navigationItem.backButtonTitle = ""
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
//            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            vkVideoCollectionView.isHidden = true
            vkPhotoCollectionView.isHidden = false
        case 1:
            if videos.isEmpty {
                NetworkManager.shared.getVideos(accessToken: accessToken) { [weak self] videos in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.videos = videos
                        self.vkVideoCollectionView.reloadData()
                    }
                }
            }
            vkVideoCollectionView.isHidden = false
            vkPhotoCollectionView.isHidden = true
        default:
            return
        }
    }
}


extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == vkPhotoCollectionView {
            let offsetY = scrollView.contentOffset.y
            // The height of the content at the moment (how far we scroll down)
            let contentHeight = scrollView.contentSize.height
            // The height of the content with the n followers
            let height = scrollView.frame.size.height
            // The height of the phone
            
            if offsetY > (contentHeight - height) {
                guard hasMorePhotos else { return }
                addPhotosToTheScreen()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == vkPhotoCollectionView {
            photosOnTheScreen.count
        } else {
            videos.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == vkPhotoCollectionView {
            if let imageURL = photosOnTheScreen[indexPath.row].sizes.first(where: { $0.type == .x }) {
                let imageURL = imageURL.url
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VkPhotoCell.reuseID, for: indexPath) as! VkPhotoCell
                cell.set(photoURL: imageURL)
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            let videoImg = videos[indexPath.row].image[2].url
            let videoTitle = videos[indexPath.row].description
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VkVideoCell.reuseID, for: indexPath) as! VkVideoCell
            cell.set(vkVideoPrevPhoto: videoImg, videoLabel: videoTitle)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == vkPhotoCollectionView {
            let destVC = VkPhotoVC(photoURL: photosOnTheScreen[indexPath.row].origPhoto.url, photoDate: Date.fromUnixTimeToRussianDateString(unixTime: photosOnTheScreen[indexPath.row].date))
            navigationController?.pushViewController(destVC, animated: true)
        } else {
            let videoURL = videos[indexPath.row].player
            let destVC = VideoPlayerVC(videoURL: videoURL)
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
}
