//
//  VKAuthVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 08.08.2024.
//

import UIKit

class VKAuthVC: UIViewController {
    let titleText = UILabel()
    let vkButton = UIButton()
    var token = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    
    private func configure() {
        view.addSubview(titleText)
        view.addSubview(vkButton)
        
        titleText.translatesAutoresizingMaskIntoConstraints = false
        vkButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleText.text = "Mobile Up \nGallery"
        titleText.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        titleText.numberOfLines = 2
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Вход через VK"
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .label
        configuration.baseForegroundColor = .systemBackground
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        vkButton.configuration = configuration
        vkButton.addTarget(self, action: #selector(vkButtonTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            vkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            vkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vkButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    @objc func vkButtonTapped() {
        let webView = WebViewVKAuth()
        webView.delegate = self
        present(webView, animated: true)
    }
}

extension VKAuthVC: WebViewDelegate {
    func didGetToken() {
        navigationController?.pushViewController(MainVC(token: token), animated: true)
    }
}
