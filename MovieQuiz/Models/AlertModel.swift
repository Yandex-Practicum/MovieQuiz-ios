import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonTexts: String
    let completions: () -> Void
}
