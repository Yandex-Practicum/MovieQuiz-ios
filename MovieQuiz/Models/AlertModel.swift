//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ruslan Batalov on 09.11.2022.
//



import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction)->Void)?
     }


