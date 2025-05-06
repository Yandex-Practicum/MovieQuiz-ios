//
//  AlertModel.swift
//  MovieQuiz

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)
}

