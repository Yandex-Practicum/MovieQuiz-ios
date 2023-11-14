//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 25/10/2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    var delegate: UIViewController? { get set }
    
    func showAlert(with alertModel: AlertModel)
}
