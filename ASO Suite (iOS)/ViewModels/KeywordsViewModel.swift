//
//  KeywordsViewModel.swift
//  ASO Suite (iOS)
//
//  Created by Niels Mouthaan on 29/11/2022.
//

import Foundation
import ASOSuiteShared

public class KeywordsViewModel: ObservableObject {
    
    private static let userDefaultsKey = "keywords"
    
    init(keywords: [Keyword]? = nil) {
        if let keywords {
            self.keywords = keywords
        } else {
            let keywords = UserDefaults.standard.stringArray(forKey: KeywordsViewModel.userDefaultsKey) ?? []
            self.keywords = keywords.map {keyword in
                return Keyword(keyword: keyword)
            }
            fetchStatistics()
        }
    }
    
    @Published public var keywords: [Keyword] {
        didSet {
            let keywords = self.keywords.map { keyword in
                return keyword.keyword
            }
            UserDefaults.standard.set(keywords, forKey: KeywordsViewModel.userDefaultsKey)
            fetchStatistics()
        }
    }
    
    private func fetchStatistics() {
        //TODO: Implement
    }
}
