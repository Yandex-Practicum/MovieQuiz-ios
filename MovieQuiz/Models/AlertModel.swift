//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Aleksey Shaposhnikov on 24.04.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let action: () -> Void
}
