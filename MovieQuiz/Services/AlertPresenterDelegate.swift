//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 25/10/2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showResults() -> Void
}
