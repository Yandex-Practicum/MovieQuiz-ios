//
//  Counter.swift
//  MovieQuiz
//
//  Created by Анастасия Хоревич on 09.07.2023.
//

import Foundation

class Counter: Changeable {
    var startValue: Int
    
    private var privateValue: Int
    
    var value: Int {
        get { privateValue }
        set {
            guard newValue > 0 else {
                return
            }
            privateValue = newValue
        }
    }
    
    init(startValue: Int) {
        privateValue = max(startValue, 0)
    }
}
