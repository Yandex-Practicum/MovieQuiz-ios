//
//  FilAlertModel.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 13.06.23.
//

import Foundation

struct AlertModel {
    let title: String //текст заголовка алерта title
    let message: String //текст сообщения алерта message
    let buttonText: String //текст для кнопки алерта buttonText
    let completion: () -> Void //замыкание без параметров для действия по кнопке алерта completion
}

