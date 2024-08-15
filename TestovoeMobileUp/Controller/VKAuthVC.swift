//
//  VKAuthVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 08.08.2024.
//

import UIKit
import AuthenticationServices

final class VKAuthVC: UIViewController {
    private let titleText = UILabel()
    private let vkButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    
    private func configure() {
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        vkButton.translatesAutoresizingMaskIntoConstraints = false
        titleText.text = "Mobile Up \nGallery"
        titleText.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        titleText.numberOfLines = 2
        
        view.addSubview(vkButton)
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
    
    
    private func startAuthentication() {
        let urlString = "https://id.vk.com/authorize?state=abracadabra&response_type=code&code_challenge=B328HskZmYqdV7WbA1tlORmTT7vA2X7xRbXP6-GvE1o&code_challenge_method=s256&client_id=52118206&redirect_uri=vk52118206://vk.com/blank.html&prompt=login&scope=photos%20video"
        guard let authURL = URL(string: urlString) else {
            showInvalidUrlAlert()
            return
        }
        let callbackURLScheme = "vk52118206"

        let authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: callbackURLScheme
        ) { [weak self] callbackURL, error in
            // Обрабатываем Alert когда пользователь закрыл окно с логином
            if let error = error as? ASWebAuthenticationSessionError, error.code == .canceledLogin {
                self?.showCancelAlert()
                return
            }
            // Обрабатываем ошибки
            guard let callbackURL = callbackURL else {
                self?.showErrorAlert()
                return
            }
            
            // Получаем AccessToken из страницы куда нас перенаправило
            self?.getAccessToken(with: callbackURL)
        }
        authSession.presentationContextProvider = self
        authSession.start()
    }
    
    
    private func getAccessToken(with callbackURL: URL) {
        let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
        guard let code = (queryItems?.first(where: { $0.name == "code" })?.value) else {
            showErrorAlert()
            return
        }

        guard let deviceId = (queryItems?.first(where: { $0.name == "device_id" })?.value) else {
            showErrorAlert()
            return
        }
        Task {
            do {
                let accessToken = try await NetworkManager.shared.getAccessToken(deviceId: deviceId, code: code)
                if let error = PersistanceManager.saveToken(token: accessToken) {
                    DispatchQueue.main.async { [weak self] in
                        self?.present(Alerts.shared.defaultAlert(withError: error), animated: true)
                    }
                }
                navigationController?.pushViewController(MainVC(accessToken: accessToken), animated: true)
            } catch {
                if let error = error as? TMUError {
                    DispatchQueue.main.async { [weak self] in
                        self?.present(Alerts.shared.defaultAlert(withError: error), animated: true)
                    }
                }
            }
        }
    }
    
    private func showInvalidUrlAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.present(Alerts.shared.problemsWithUrlAlert(), animated: true)
        }
    }
    
    private func showErrorAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.present(Alerts.shared.showErrorLoginAlert(), animated: true)
        }
    }
    
    private func showCancelAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.present(Alerts.shared.showAuthWasCanceledAlert(), animated: true)
        }
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
