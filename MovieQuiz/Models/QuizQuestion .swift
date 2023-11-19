//
//  QuestioQuiz.swift
//  MovieQuiz
//
//  Created by Fedor on 14.11.2023.
//

import Foundation

//Структура вопроса квиза
struct QuizQuestion {
    //Строка с названием фильма
    //Совпадает с названием картинки афиши фильма в Assets
    var image: String
    
    //Строка с названием вопроса о фильме
    var text: String
    
    //Будевое значение (true, false), дающее правильный ответ на вопрос
    var correctAnswer: Bool
}
