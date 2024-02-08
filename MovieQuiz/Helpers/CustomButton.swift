//
//  CustomButton.swift
//  MovieQuiz
//
//  Created by Александр Верповский on 29.01.2024.
//

import UIKit

final class CustomButton: UIButton {
    // MARK: - Type alias
    private typealias FontName = Constants.FontName
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .ypWhite
        self.layer.cornerRadius = 15
        self.titleLabel?.textColor = .ypBlack
        self.titleLabel?.font = UIFont(name: FontName.ysDisplayMedium.rawValue, size: 20)
    }
    
    
}
