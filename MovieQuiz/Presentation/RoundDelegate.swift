//
//  RoundDelegate.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 21.12.2023.
//

import UIKit

protocol RoundDelegate: AnyObject {
    func didReceiveNewQuestion(_ question: QuizQuestion?)
    func roundDidEnd(_ round: Round, withResult gameRecord: GameRecord)
}
