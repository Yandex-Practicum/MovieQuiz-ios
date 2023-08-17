//
//  UIButton+setButton.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 13.08.2023.
//

import UIKit

extension UIButton {
    public func setButton(buttonName: String) {
        self.titleLabel?.font = UIFont(name: Settings.buttonsFontName, size: Settings.buttonsFontSize)
        self.setTitle(buttonName, for: .normal)
        self.frame.size.width = Settings.buttonsWidth
        self.frame.size.height = Settings.buttonsHeight
        self.layer.cornerRadius = Settings.buttonsRadius
        self.backgroundColor = Settings.buttonsBackgroundColor
        self.tintColor = Settings.buttonsTintColor
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .center
    }
}

