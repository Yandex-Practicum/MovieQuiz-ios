import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YY HH:mm"
    return dateFormatter
}()

extension Date {
    var ddMMYYHHmm: String { dateTimeDefaultFormatter.string(from: self) }
}
