//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Егор Свистушкин on 31.12.2022.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    
    var viewController: UIViewController { get }
}
