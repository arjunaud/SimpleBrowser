//
//  SearchService.swift
//  Browser
//
//  Created by Arjuna on 3/28/21.
//

import Foundation

struct Suggestion {
    let suggestionString: String
}

protocol SearchService {
    func suggestionsFor(query:String,  completion: @escaping ([Suggestion]) -> Void)
    func urlRequestForSearchString(searchString:String) -> URLRequest
}

class SearchServiceProvider: SearchService {
    func suggestionsFor(query: String, completion: @escaping ([Suggestion]) -> Void) {
        let url = URL(string: "https://www.google.com/complete/search?client=firefox&q=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url!)) { (data, response, error) in
            var suggestions: [Suggestion] = []
            if let jsonData = data {
                let jsonArray = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                if let jsonArray = jsonArray as? [Any], jsonArray.count > 1 {
                    if let suggestionArray = jsonArray[1] as? [String] {
                        suggestions = suggestionArray.map {
                            Suggestion(suggestionString: $0)
                        }
                    }
                }
            }
            completion(suggestions)
        }
        dataTask.resume()
    }
    
    func urlRequestForSearchString(searchString:String) -> URLRequest {
        let url = URL(string: "https://www.google.com/search?client=firefox&q=\(searchString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        return URLRequest(url: url)
    }
}
