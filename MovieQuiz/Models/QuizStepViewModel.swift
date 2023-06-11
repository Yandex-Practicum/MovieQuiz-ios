//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 11.06.23.
//

import UIKit
//Такой тип моделей называют ViewModel. Это специальная модель, содержащая информацию, подготовленную именно для отображения на экране.
struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}
