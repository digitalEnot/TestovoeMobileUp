//
//  TMUError.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 09.08.2024.
//

import Foundation

enum TMUError: String, Error {
    case unableToLogIn = "Произошла ошибка при входе. Попробуй выйти из аккаунта и зайти снова."
    case unableToSaveToken = "Произошла ошибка. При повторном входе в приложение нужно будет снова войти в аккаунт."
    case problemsWithTheNetwork = "Произошла ошибка при загрузке медиаконтента. Проверь свое интернет соединение."
    case tokenHasExpired = "Сессия завершена. Нужно войти в свой аккаунт."
    case problemsWithURL = "У нас возникли проблемы. Уже делаем все возможное чтобы их решить!"
    case problemsWithConvertingDataIntoImage = "Возникли неполадки при отображении контента. Скоро все починим!"
    case problemsWithToken = "Произошла ошибка при входе в аккаунт попробуй еще раз."
    case authCanceled = "Нажми на кнопку вход еще раз."
}
