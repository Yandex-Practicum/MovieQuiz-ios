//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 26.07.2023.
//

import Foundation
import UIKit

protocol QuestionFactoryDelegate: AnyObject {
func didReceiveNextQuestion(question: QuizQuestion?)
}


   


