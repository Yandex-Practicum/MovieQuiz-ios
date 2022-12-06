//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Александр Зиновьев on 06.12.2022.
//

import Foundation

protocol NetworkRouting {

    func fetch(url: URL, handler: @escaping (Result<Data,Errors>) -> Void)
        
}
