//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Ilya Shirokov on 27.12.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alert: UIAlertController?)
}
