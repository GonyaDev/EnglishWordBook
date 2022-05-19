//
//  Presenter .swift
//  EnglishWordBook
//
//  Created by Алексей Гончаров on 5/17/22.
//

import Foundation
import UIKit

class SearchPresenter {
    
    let apiService: APIService = APIServiceImpl()
    
    weak var view: SearchViewController?
    
    func didSearch(text: String) {
        guard !text.isEmpty else {
            return
        }
        do {
            try apiService.getData(for: text, completionHandler: searchCompletionHandler(data:))
        } catch {
            print(error)
        }
    }
    
    private func searchCompletionHandler(data: WordData) {
        DispatchQueue.main.async {
            self.view?.show(wordData: data)
        }
    }
}
