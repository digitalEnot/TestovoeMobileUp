//
//  VideoPlayerVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 13.08.2024.
//

import UIKit
import WebKit

final class VideoPlayerVC: UIViewController {
    private let videoURL: String
    private let webView = WKWebView()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    init(videoURL: String) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        configure()
    }
    
    
    private func configureNavigationItems() {
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareButtonTapped))
    }
    
    private func configure() {
        if let url = URL(string: videoURL) {
            view.addSubview(webView)
            webView.backgroundColor = .white
            webView.isOpaque = false
            webView.allowsBackForwardNavigationGestures = true
            webView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.heightAnchor.constraint(equalToConstant: 250)
            ])
            webView.load(URLRequest(url: url))
        } else {
            present(Alerts.shared.problemsWithUrlAlert(), animated: true)
        }
    }
    
    
    @objc func shareButtonTapped() {
        let shareSheetVC = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
}
