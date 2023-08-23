//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 30.07.2023.
//
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (UIAlertAction) -> Void
}
