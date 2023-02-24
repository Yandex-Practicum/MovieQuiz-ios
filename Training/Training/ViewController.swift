//
//  ViewController.swift
//  Training
//
//  Created by Игорь Полунин on 16.02.2023.
//

import UIKit

class ViewController: UIViewController {
    struct Actor: Codable {
        let id: String
        let image: String
        let name: String
        let asCharacter: String
    }

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

    struct Top: Decodable {
        let items: [Movie]
    }
    override func viewDidLoad() {
        
      
       
            super.viewDidLoad()
    
      
        Bundle.main.path(forResource: "top250MoviesIMBD", ofType: "json")
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "top250MoviesIMDB.json"
        documentsURL.appendPathComponent(fileName)
        print(documentsURL)
        let jsonString = try? String(contentsOf:URL(fileURLWithPath: "top250MoviesIMDB.json",relativeTo: documentsURL))
        let data = jsonString?.data(using: .utf8)!

        do {
            let list = try JSONDecoder().decode(Top.self, from:data!)
            print(list.id)
        } catch {
            print(error)
        }


        // Do any additional setup after loading the view.
   }
//
//
}

