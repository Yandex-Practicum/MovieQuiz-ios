//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by Fedor on 14.11.2023.
//

import Foundation

//Структура состояния "результат квиза"
struct QuizResultViewModel {
    //Строка с заголовком alert
    var title: String
    
    //Строка с текстом количества набранных очков
    var text: String
    
    //Текст для кнопки Alert
    var buttonText: String
}
