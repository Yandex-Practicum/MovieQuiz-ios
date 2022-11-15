//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Veniamin on 13.11.2022.
//

import Foundation


struct AlertModel{
    let title: String
    let text: String
    let buttonText: String
    
    var completition:() -> Void
}
