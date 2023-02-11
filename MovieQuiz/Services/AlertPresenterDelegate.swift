//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 08.02.2023.
//

import Foundation
protocol AlertPresenterDelegate: AnyObject{
    func didRecieveAlertModel (alertModel:AlertModel?)
}
