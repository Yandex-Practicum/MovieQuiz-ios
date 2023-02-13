//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 08.02.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject{
    func present(_ alertController: UIAlertController) 
}
