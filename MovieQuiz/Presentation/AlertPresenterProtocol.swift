//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Ярослав Калмыков on 18.12.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func createAlert(alertModel: AlertModel?)
}
