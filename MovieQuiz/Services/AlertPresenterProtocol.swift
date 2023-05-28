//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Эльдар Айдумов on 21.05.2023.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func show (quiz model: AlertModel)
}
