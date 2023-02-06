//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Влад on 12.01.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(model: AlertModel)
}
