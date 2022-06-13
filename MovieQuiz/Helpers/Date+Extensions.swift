//
//  Date+Extensions.swift
//  MovieQuiz
//
//  Created by Constantine Nikolsky on 14.06.2022.
//

import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YY hh:mm"
    return dateFormatter
}()

extension Date {
    var dateTimeString: String { dateTimeDefaultFormatter.string(from: self) }
}
