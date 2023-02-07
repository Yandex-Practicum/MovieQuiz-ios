//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created on 08.01.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present( _ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? )
}
