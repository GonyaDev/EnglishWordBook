//
//  APIService.swift
//  EnglishWordBook
//
//  Created by Алексей Гончаров on 5/11/22.
//

import Foundation

protocol APIService {
    
    func getData(for word: String, completionHandler: @escaping (WordData) -> Void) throws

}

final class APIServiceImpl: APIService {
    
    func getData(for word: String, completionHandler: @escaping (WordData) -> Void) throws {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else {
            throw NSError(domain: "No word", code: 1, userInfo: nil)
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _ , error in
            guard let data = data else {
                return
            }
            do {
                let test = String(data:data, encoding: .utf8)
                let result = try JSONDecoder().decode([WordData].self, from: data)
                completionHandler(result[0])
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}


struct WordData: Decodable {
    let word: String
    let phonetics: [PhoneticData]
    let meanings: [MeaningData]
}

struct PhoneticData: Decodable {
    let text: String?
    let audio: String?
}

struct MeaningData: Decodable {
    let partOfSpeech: String
    let definitions: [DefinitionData]
    
    var firstDefinition: DefinitionData? {
        definitions.first
    }
}

struct DefinitionData: Decodable {
    let definition: String
    let example: String?
}
