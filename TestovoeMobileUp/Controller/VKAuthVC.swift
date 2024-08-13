//
//  VKAuthVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 08.08.2024.
//

import UIKit
import AuthenticationServices

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
    
    func startAuthentication() {
        let authURL = URL(string: "https://id.vk.com/authorize?state=abracadabra&response_type=code&code_challenge=B328HskZmYqdV7WbA1tlORmTT7vA2X7xRbXP6-GvE1o&code_challenge_method=s256&client_id=52118206&redirect_uri=vk52118206://vk.com/blank.html&prompt=login&scope=photos")!
        let callbackURLScheme = "vk52118206"

        let authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: callbackURLScheme
        ) { callbackURL, error in
            if let error = error {
                print("Authentication failed with error: \(error.localizedDescription)")
                return
            }

            guard let callbackURL = callbackURL else {
                print("Authentication failed: No callback URL")
                return
            }
            
            // Заменить на безопасное развертывавние
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            let code = (queryItems?.first(where: { $0.name == "code" })?.value)!
            let deviceId = (queryItems?.first(where: { $0.name == "device_id" })?.value)!
            TokenManager.shared.getAccessToken(deviceId: deviceId, code: code) { accessToken in
                print(accessToken)
                if let error = PersistanceManager.saveToken(token: accessToken) {
                    print(error)
                }
                // TODO: проверить на утечку памяти
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(MainVC(accessToken: accessToken), animated: true)
                }
            }

//            if let authCode = authCode {
//                print("Authorization code: \(authCode)")
//            }
        }
        authSession.presentationContextProvider = self
        authSession.start()
    }
    
    
    @objc func vkButtonTapped() {
        startAuthentication()
    }
}

extension VKAuthVC: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
