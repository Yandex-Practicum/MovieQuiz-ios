//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Руслан Коршунов on 05.09.23.
//
import UIKit
import Foundation

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    let buttonAction: () -> Void
}
