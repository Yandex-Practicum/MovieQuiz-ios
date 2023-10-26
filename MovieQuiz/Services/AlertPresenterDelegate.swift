//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 25/10/2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    var currentQuestionIndex: Int { get set }
    var correctAnswers: Int { get set }
    
    func showResults(alert: UIAlertController, action: UIAlertAction)
}
