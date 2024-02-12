//
//  AlertDelegate.swift
//  MovieQuiz
//
//  Created by Дмитрий on 10.02.2024.
//

import UIKit

protocol AlertDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
