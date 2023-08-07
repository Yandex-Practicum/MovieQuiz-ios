//
//  Constants.swift
//  MovieQuiz
//
//  Created by Иван Доронин on 07.08.2023.
//

import UIKit

struct Constants {
    struct Colors {
        static let background = UIColor(named: "YP Background")
        static let black = UIColor(named: "YP Black")
        static let gray = UIColor(named: "YP Gray")
        static let green = UIColor(named: "YP Green")
        static let red = UIColor(named: "YP Red")
        static let white = UIColor(named: "YP White")
    }
    
    struct Fonts {
        static func ysDisplayFont(named: String, size: CGFloat) -> UIFont {
            UIFont(name: "YSDisplay-" + named, size: size) ?? UIFont()
        }
    }
}
