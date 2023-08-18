//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 19.07.2023.
//

import Foundation
import UIKit

protocol AlertProtocol {
    func requestAlert(in vc: UIViewController, alertModel: AlertModel)
}
