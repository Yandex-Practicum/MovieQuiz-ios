//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александр Ершов on 03.12.2022.
//
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: ((UIAlertAction) -> Void )
}
