//
//  JSONLoader.swift
//  elevensystems_test
//
//  Created by Calin Cristian on 26/02/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

struct JSONLoader {
    
    static func decode(data: Data) throws -> [ContactItem] {
        do {
            let decoder = JSONDecoder()
            let contacts = try decoder.decode([ContactItem].self, from: data)
            return contacts
        } catch let error {
            print(error)
            return []
        }
    }
    
    static func loadJSON(file name: String) -> [ContactItem] {
        
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: "json") else {
            print("couldn't find the file")
            return []
        }
        
        do {
            let content = try Data(contentsOf: fileURL)
            let contacts = try decode(data: content)
            return contacts

        } catch let error {
            print(error)
            return []
        }
    }
}
