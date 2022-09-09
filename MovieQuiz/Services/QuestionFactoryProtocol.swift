//
// Created by Ислам Нурмухаметов on 08.09.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion(completion: (QuizQuestion?) -> Void)
}
