//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Ярослав Калмыков on 17.12.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject{
    func showAlert(alert: UIAlertController)
}
