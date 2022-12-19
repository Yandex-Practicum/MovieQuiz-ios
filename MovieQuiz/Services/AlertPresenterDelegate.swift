//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Дмитрий Редька on 27.11.2022.
//


import UIKit
protocol AlertPresenterDelegate: AnyObject {
    func didPresentAlert(alert: UIAlertController?)
}
