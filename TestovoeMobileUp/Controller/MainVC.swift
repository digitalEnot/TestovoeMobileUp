//
//  MainVC.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 09.08.2024.
//

import UIKit

class MainVC: UIViewController {
    
    var token: String
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = " MobileUP Gallery"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход", style: .done, target: self, action: #selector(logOut))
    }
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЗДАРОВА"
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func logOut() {
        print("you logged out")
        do {
           try PersistanceManager.updateWith(token: "", actionType: .remove)
        } catch {
            // переделать на алерт
            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
}
