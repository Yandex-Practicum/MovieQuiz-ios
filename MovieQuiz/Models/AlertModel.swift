//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 08.11.2022.
//
import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let buttonText: String?
    
    let completion: () -> Void?
}
