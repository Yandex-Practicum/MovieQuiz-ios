//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Yuriy Varvenskiy on 07.08.2023.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String?
    let message: String?
    let buttonText: String
    let completion: (() -> Void)
}





