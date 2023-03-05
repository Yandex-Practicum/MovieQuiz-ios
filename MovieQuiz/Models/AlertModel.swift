//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Видич Анна  on 25.2.23..
//

import Foundation
import UIKit

struct AlertModel {
     let title: String
     let message: String?
     let buttonText: String?
     let completion: ((UIAlertAction)->Void)?
 }
