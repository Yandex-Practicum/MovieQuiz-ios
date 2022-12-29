//
//  MovieModel.swift
//  MovieQuiz
//
//  Created by Алексей on 12.12.2022.
//

import Foundation

struct Movie: Codable {
  let id: String
  let rank: String
  let title: String
  let fullTitle: String
  let year: String
  let image: String
  let crew: String
  let imDbRating: String
  let imDbRatingCount: String
}
