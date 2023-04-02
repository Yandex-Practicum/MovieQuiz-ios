//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Mir on 31.03.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)

    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}
