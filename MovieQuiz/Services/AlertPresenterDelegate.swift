//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 7.01.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didPresentAlert(alert: UIAlertController?)
}
