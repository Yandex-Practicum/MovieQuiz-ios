//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ivan on 12.07.2023.
//
import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completition: () -> ()?
}
