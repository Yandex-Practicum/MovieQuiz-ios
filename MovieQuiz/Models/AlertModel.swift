//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 30.07.2023.
//


import UIKit

struct AlertModel{
    var title: String
    var message: String
    var buttonText: String
    var completion: (UIAlertAction) -> Void
}

