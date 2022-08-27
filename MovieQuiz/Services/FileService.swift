import Foundation

class FileService {
    enum FileManagerError: Error {
        case fileDoesntExist
    }

    func string(from fileURL: URL) throws -> String {
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            throw FileManagerError.fileDoesntExist
        }
        var str = ""
        do {
            str = try String(contentsOf: fileURL)
        } catch FileManagerError.fileDoesntExist {
            print("File on URL \(fileURL.path) doesn't exist")
        } catch {
            print("Unknown error")
        }
        return str
    }
}
