//
//  AlertDelegate.swift
//  MovieQuiz
//
//  Created by Aleksandr Eliseev on 31.10.2022.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func alertPresent(alert: UIAlertController?)
}
