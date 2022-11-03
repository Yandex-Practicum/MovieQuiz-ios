//
//  JSON+Functions.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 10/21/22.
//

import Foundation

enum FileManagerError: Error {
    case FileDoesntExist
}

/*
func string(from documentURL: URL) throws -> String {
    if !FileManager.default.fileExists(atPath: documentURL.path) {
        throw FileManagerError.FileDoesntExist
    } else {
        return try String(contentsOf: documentURL)
    }
}
*/

class IdsConverter {
    func getFile (fileName: String, Kind: String) -> Top? {
        guard
            let path = Bundle.main.path(forResource: fileName, ofType: Kind),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let jsonDict = try? JSONDecoder().decode(Top.self, from: jsonData)
        else {
            print("IdsConverter: ❌")
            return nil
        }
        print("IdsConverter: ✅")
        return jsonDict
    }
}
