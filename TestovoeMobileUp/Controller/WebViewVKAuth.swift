//
//  WebViewVKAuth.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 08.08.2024.
//

import UIKit
import WebKit

class WebViewVKAuth: UIViewController, WKNavigationDelegate {
    
    let webView = WKWebView()
    let url = "https://oauth.vk.com/authorize?client_id=52118206&redirect_uri =http://oauth.vk.com/blank.html&scope=12&display=mobile"
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: url)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

//    func configure() {
//        view.addSubview(webView)
//        webView.translatesAutoresizingMaskIntoConstraints = true
//        webView.load(URLRequest(url: URL(string: url)!))
//        
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: view.topAnchor),
//            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
}

