//
//  MainVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 09.08.2024.
//

import UIKit

final class MainVC: UIViewController {
    var accessToken: String
    private let segment = UISegmentedControl(items: ["Фото", "Видео"])
    private var vkPhotoCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var vkVideoCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var photos: [Photo] = []
    private var videos: [Video] = []
    private var hasMorePhotos = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegment()
        configureNavItems()
        configureCollectionView()
        getPhotos()
    }
    
    
    init(accessToken: String) {
        self.accessToken = accessToken
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func getPhotos() {
        NetworkManager.shared.getPhotos(accessToken: accessToken, offset: photos.count) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos.items)
                    self.vkPhotoCollectionView.reloadData()
                    self.hasMorePhotos = self.photos.count < photos.count ? true : false
                }
                
            case .failure(let error):
                showAlert(withError: error)
            }
        }
    }
    
    
    private func getVideos() {
        NetworkManager.shared.getVideos(accessToken: accessToken) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let videos):
                DispatchQueue.main.async {
                    self.videos = videos
                    self.vkVideoCollectionView.reloadData()
                }
                
            case .failure(let error):
                showAlert(withError: error)
            }
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
    
    private func configureSegment() {
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
            view.addSubview(vkPhotoCollectionView)
            vkPhotoCollectionView.delegate = self
            vkPhotoCollectionView.dataSource = self
            vkPhotoCollectionView.backgroundColor = .systemBackground
            vkPhotoCollectionView.register(VkPhotoCell.self, forCellWithReuseIdentifier: VkPhotoCell.reuseID)
            vkPhotoCollectionView.translatesAutoresizingMaskIntoConstraints = false
            
            vkVideoCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createOneRectangleColumnLayout(in: view))
            view.addSubview(vkVideoCollectionView)
            vkVideoCollectionView.isHidden = true
            vkVideoCollectionView.delegate = self
            vkVideoCollectionView.dataSource = self
            vkVideoCollectionView.backgroundColor = .systemBackground
            vkVideoCollectionView.register(VkVideoCell.self, forCellWithReuseIdentifier: VkVideoCell.reuseID)
            vkVideoCollectionView.translatesAutoresizingMaskIntoConstraints = false
            
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
        }
    
    
    private func showAlert(withError error: TMUError) {
        let alertController = UIAlertController(
            title: "Oшибка",
            message: error.rawValue,
            preferredStyle: .alert
        )
        if error == .tokenHasExpired {
            alertController.addAction(UIAlertAction(title: "Выйти", style: .default) { _ in
                self.logOut()
            })
        } else {
            alertController.addAction(UIAlertAction(title: "Ок", style: .default))
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    
    @objc func logOut() {
        PersistanceManager.deleteToken()
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if photos.isEmpty {
                getPhotos()
            }
            vkVideoCollectionView.isHidden = true
            vkPhotoCollectionView.isHidden = false
        case 1:
            if videos.isEmpty {
                getVideos()
            }
            vkVideoCollectionView.isHidden = false
            vkPhotoCollectionView.isHidden = true
        default:
            return
        }
    }
}


extension MainVC: UICollectionViewDelegate {
    // Загружаем фотографии порциями по 30 штук. Как только юзер долистывает до конца подгружаются новые
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == vkPhotoCollectionView {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if offsetY > (contentHeight - height) {
                guard hasMorePhotos else { return }
                getPhotos()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == vkPhotoCollectionView {
            photos.count
        } else {
            videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == vkPhotoCollectionView {
            let photoUrl = photos[indexPath.row].origPhoto.url
            let title = Date.fromUnixTimeToRussianDateString(unixTime: photos[indexPath.row].date)
            
            let destVC = VkPhotoVC(photoURL: photoUrl)
            destVC.title = title
            navigationController?.pushViewController(destVC, animated: true)
        } else {
            let videoURL = videos[indexPath.row].player
            let title = videos[indexPath.row].title
            
            let destVC = VideoPlayerVC(videoURL: videoURL)
            destVC.title = title
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
}


extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == vkPhotoCollectionView {
            // Ищем url c фото нужного разрешения
            if let imageURL = photos[indexPath.row].sizes.first(where: { $0.type == .x }) {
                let imageURL = imageURL.url
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VkPhotoCell.reuseID, for: indexPath) as! VkPhotoCell
                Task {
                    do {
                        let photo = try await NetworkManager.shared.downloadVkPhoto(from: imageURL)
                        cell.set(photo: photo)
                    } catch {
                        present(Alerts.shared.defaultAlert(withError: error), animated: true)
                    }
                }
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            // Ищем url с фото самого высокого разрешения
            let videoImg = videos[indexPath.row].image.max(by: { $0.width < $1.width })?.url ?? videos[indexPath.row].image[0].url
            let videoTitle = videos[indexPath.row].title
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VkVideoCell.reuseID, for: indexPath) as! VkVideoCell
            Task {
                do {
                    let prevVideo = try await NetworkManager.shared.downloadVkPhoto(from: videoImg)
                    cell.set(vkVideoPrevPhoto: prevVideo, videoTitle: videoTitle)
                } catch {
                    present(Alerts.shared.defaultAlert(withError: error), animated: true)
                }
            }
            return cell
        }
    }
}
