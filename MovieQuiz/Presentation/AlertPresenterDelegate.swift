//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Vladimir Vinageras on 14.12.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject{
    func didTappedAlertButton()
    
    func willShowAlert(alert: UIViewController)
}
