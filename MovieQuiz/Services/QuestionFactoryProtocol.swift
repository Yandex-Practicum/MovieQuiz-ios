//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Aleksey Shaposhnikov on 24.04.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
}
