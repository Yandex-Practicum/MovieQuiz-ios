//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.09.2023.
//

import Foundation

//Структура AlertModel должна содержать:
//текст заголовка алерта title
//текст сообщения алерта message
//текст для кнопки алерта buttonText
//замыкание без параметров для действия по кнопке алерта completion

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void

    // completion- завершение
}


