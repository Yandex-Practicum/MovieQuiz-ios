//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 25/10/2023.
//

import Foundation

protocol AlertPresenterProtocol {
    var delegate: AlertPresenterDelegate? { get set }
    
    func alertSignal(alertModel: AlertModel)
}
