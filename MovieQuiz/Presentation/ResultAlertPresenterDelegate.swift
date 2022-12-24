//
//  ResultAlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Григорий Сухотин on 06.12.2022.
//

import UIKit

protocol ResultAlertPresenterDelegate: AnyObject {
    func didRecieveAlert(alert: UIAlertController)
}
