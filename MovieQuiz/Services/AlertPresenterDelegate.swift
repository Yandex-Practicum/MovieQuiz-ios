//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Келлер Дмитрий on 04.01.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present( _ viewControllerToPresent: UIViewController,
                  animated flag: Bool,
                  completion: (() -> Void)?)
}
