//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by admin on 02.01.2024.
//

import Foundation

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    var delegate: AlertPresenterDelegate? {get set}
    func show(alertModel: AlertModel)
}


