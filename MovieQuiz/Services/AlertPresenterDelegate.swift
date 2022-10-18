//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 11.10.2022.
//
import UIKit
import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func didShowAlert(controller: UIAlertController?)
}
