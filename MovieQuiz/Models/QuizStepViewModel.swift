//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Fedor on 14.11.2023.
//

import UIKit

//Структура модели вопроса нашего квиза для обновления View
struct QuizStepViewModel {
    //картинка с постером фильма
    var image: UIImage
    
    //Название вопроса
    var question: String
    
    //Порядковый номер вопроса
    var questionNumber: String
    
}
