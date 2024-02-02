//
//  CustomButton.swift
//  MovieQuiz
//
//  Created by Александр Верповский on 02.02.2024.
//

import UIKit

final class CustomButton: UIButton {
    // MARK: - Type alias
       private typealias FontName = Constants.FontName
       
       override init(frame: CGRect){
           super.init(frame: frame)
           self.layer.cornerRadius = 15
           self.backgroundColor = .ypWhite
           self.titleLabel?.textColor = .ypBlack
           self.titleLabel?.font = UIFont(name: FontName.ysDisplayMedium.rawValue, size: 20)
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }

       override func layoutSubviews() {
           super.layoutSubviews()
       }
}
