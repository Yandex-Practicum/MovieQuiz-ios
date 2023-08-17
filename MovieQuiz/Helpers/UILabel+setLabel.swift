//
//  UILabel+setLabel.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 13.08.2023.
//

import UIKit

extension UILabel {
    public func setLabel(text: String, type: String? = nil) {
        var fontSize: CGFloat = Settings.questionLabelFontSize
        var textAlignment: NSTextAlignment = Settings.questionLabelTextAlignment
        var fontName: String = Settings.questionLabelFontName
        if type == "NavigationLeft" {
            fontSize = Settings.navigationLabelFontSize
            textAlignment = Settings.navigationLeftTextAlignment
            fontName = Settings.buttonsFontName
        } else if type == "NavigationRight" {
            fontSize = Settings.navigationLabelFontSize
            textAlignment = Settings.navigationRightTextAlignment
            fontName = Settings.buttonsFontName
        }
        self.text = text
        self.font = UIFont(name: fontName, size: fontSize)
        self.baselineAdjustment = .alignCenters
        self.textAlignment = textAlignment
    }
}
