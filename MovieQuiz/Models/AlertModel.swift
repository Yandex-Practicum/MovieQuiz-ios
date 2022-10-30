//
//  Alert.swift
//  MovieQuiz
//
//  Created by Alexey Tsidilin on 26.10.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}


/*
 Структура AlertModel должна содержать:
 текст заголовка алерта title
 текст сообщения алерта message
 текст для кнопки алерта buttonText
 замыкание без параметров для действия по кнопке completion
 */
