import Foundation

extension Double {
    func rounding(before count: Int) -> Double {
        let divisor = pow(10.0, Double(count))
        return (self * divisor).rounded() / divisor
    }
}
