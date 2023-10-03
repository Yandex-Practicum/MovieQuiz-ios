//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by LERÄ on 03.10.23.
//


import Foundation
import UIKit

struct AlertModel {
    
    let title : String
    let message: String
    let textButton: String
    let completion: () -> Void
}

