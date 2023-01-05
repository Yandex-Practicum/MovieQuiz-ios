//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Арсений Убский on 22.11.2022.
//
import UIKit
protocol ViewControllerProtocol: class {
    func present(alert: UIAlertController, animated: Bool, completion: ()->Void)
}

struct AlertPresenter: AlertPresenterProtocol {
    weak private var viewController: UIViewController?
    //иньектируем viewController через инициализатор
    init(viewController: UIViewController?){
        self.viewController = viewController
    }
    
    func show(results:AlertModel) {
        let alert = UIAlertController(title: results.title,
                                      message: results.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: results.buttonText, style: .default, handler: { _ in
            results.completion()
        })
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
