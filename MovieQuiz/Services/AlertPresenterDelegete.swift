//
//  AlertPresenterDelegete.swift
//  MovieQuiz
//
//  Created by Дмитрий Бучнев on 26.09.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didPresent(alert: UIAlertController?)
}
