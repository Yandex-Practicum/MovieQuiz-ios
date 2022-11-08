//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 08.11.2022.
//
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    func present(model: AlertModel)
}
