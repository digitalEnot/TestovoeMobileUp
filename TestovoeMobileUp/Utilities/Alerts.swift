//
//  Alerts.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 15.08.2024.
//

import UIKit

final class Alerts {
    static let shared = Alerts()
    private init() {}
    
    func defaultAlert(withError error: Error) -> UIAlertController {
        if let error = error as? TMUError {
            let alertController = UIAlertController(
                title: "Ошибка",
                message: error.rawValue,
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Ок", style: .default))
            return alertController
        } else {
//            let alertController = UIAlertController(
//                title: "Ошибка",
//                message: error.localizedDescription,
//                preferredStyle: .alert
//            )
//            alertController.addAction(UIAlertAction(title: "Ок", style: .default))
//            return alertController
            return UIAlertController()
        }
    }
    
    
    func problemsWithUrlAlert() -> UIAlertController {
        let alertController = UIAlertController(
            title: "Oшибка",
            message: TMUError.problemsWithURL.rawValue,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Ок", style: .default))
        return alertController
    }
    
    
    func showErrorLoginAlert() -> UIAlertController {
        let alertController = UIAlertController(
            title: "Вход был прерван",
            message: "Попробуй еще раз",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Ок", style: .default))
        return alertController
    }
    
    
     func showAuthWasCanceledAlert() -> UIAlertController {
        let alertController = UIAlertController(
            title: "Вход был прерван",
            message: TMUError.authCanceled.rawValue,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Ок", style: .default))
        return alertController
    }
    
    func showPhotoAddedSuccessfully() -> UIAlertController {
        let alertController = UIAlertController(title: "Сохранили!", message: "Эта фотография была сохранена в твою галерею.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        return alertController
    }
}
