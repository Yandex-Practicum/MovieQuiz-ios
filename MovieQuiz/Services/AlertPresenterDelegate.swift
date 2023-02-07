//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Леонид Турко on 25.01.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func alertPresent(_ alert: UIAlertController)
}
