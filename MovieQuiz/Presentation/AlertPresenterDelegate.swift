//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Влад on 12.01.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (()-> Void)?)
}
