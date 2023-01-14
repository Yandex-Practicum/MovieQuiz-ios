//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 11.01.2023.
//

import UIKit

 struct AlertModel {
     let title: String
     let message: String
     let buttonText: String
     let completion: ((UIAlertAction) -> Void)?
 }
