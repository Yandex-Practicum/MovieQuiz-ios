//
//  MovieQuizControllerProtocol.swift
//  MovieQuiz
//
//  Created by Fedor on 25.12.2023.
//

import Foundation
import UIKit

protocol MovieQuizControllerProtocol: AnyObject {
    
    var imageView: UIImageView! { get set }
    
    func show(quiz step: QuizStepViewModel)

    func showLoadingIndictor()
    
    func hideLoadingIndicator()
    
    func isButtonsBlocked(state: Bool)
}
