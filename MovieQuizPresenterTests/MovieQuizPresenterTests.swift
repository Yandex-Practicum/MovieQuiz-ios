//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Alexey on 12.02.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {

    func testConvertModels() {
        let presenter = MovieQuizPresenter()
        let imageData = UIImage(systemName: "checkmark")!.pngData()!
        let data = QuizQuestion(image: imageData, text: "Проверка", correctAnswer: true)
        let result = presenter.convert(model: data)
        XCTAssertEqual(result.image.pngData(), UIImage(data: imageData)?.pngData())
        XCTAssertEqual(result.question, data.text)
       XCTAssertEqual(result.questionNumber, "1/10")

        
        
    }
}





        //    //10 вопросов квиза представлены в виде массива
        //    private let questions: [QuizQuestion] = [
        //        QuizQuestion(imageName: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //        QuizQuestion(imageName: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //        QuizQuestion(imageName: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //        QuizQuestion(imageName: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //        QuizQuestion(imageName: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        //        QuizQuestion(imageName: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        //        QuizQuestion(imageName: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        //        QuizQuestion(imageName: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        //        QuizQuestion(imageName: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        //        QuizQuestion(imageName: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
        //    ]
