//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Aleksey Kosov on 27.12.2022.
//


struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (()->())
}
