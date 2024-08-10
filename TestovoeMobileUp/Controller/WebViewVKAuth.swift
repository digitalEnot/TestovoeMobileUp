//
//  WebViewVKAuth.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 08.08.2024.
//

import UIKit
import WebKit
import AuthenticationServices

protocol WebViewDelegate: AnyObject {
    func didGetToken()
}

class WebViewVKAuth: UIViewController {
    weak var delegate: WebViewDelegate?
    let webView = WKWebView()
    let url = "https://oauth.vk.com/authorize?client_id=52118206&redirect_uri =http://oauth.vk.com/blank.html&scope=12&display=mobile"
    
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}

extension WebViewVKAuth: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map{$0.components(separatedBy: "=")}
            .reduce([String:String]()) { res, param in
                var dict = res
                let key = param[0]
                let value = param[1]
                dict[key] = value
                
                return dict
            }
        
        if let accessToken = params["access_token"] {
            if let error = PersistanceManager.saveToken(token: accessToken) {
                // Добавить alert
                print(error)
            }
            self.dismiss(animated: true)
            let vkAuthVC = delegate as? VKAuthVC
            vkAuthVC?.token = accessToken
            delegate?.didGetToken()
        }
        decisionHandler(.cancel)
    }
}

