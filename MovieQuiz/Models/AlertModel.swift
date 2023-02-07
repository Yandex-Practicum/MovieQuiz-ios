//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Иван Иванов on 08.01.2023.
//

import Foundation

struct AlertModel {
  let title: String
  let text: String
  let buttonText: String
  let completion: (()->Void)
}
