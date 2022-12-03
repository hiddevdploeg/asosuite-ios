//
//  KeywordsViewModel.swift
//  ASO Suite (iOS)
//
//  Created by Niels Mouthaan on 29/11/2022.
//

import Foundation
import ASOSuiteShared

@MainActor
public class KeywordsViewModel: ObservableObject {
    
    private static let userDefaultsKey = "keywords"
    
    @Published public private(set) var keywords: [Keyword]
    
    init(keywords: [Keyword]? = nil) {
        if let keywords {
            self.keywords = keywords
        } else {
            let keywords = UserDefaults.standard.stringArray(forKey: KeywordsViewModel.userDefaultsKey) ?? []
            self.keywords = keywords.map { keyword in
                return Keyword(keyword: keyword)
            }
            updateStatistics()
        }
    }
    
    public func removeKeyword(atOffsets offsets: IndexSet) {
        keywords.remove(atOffsets: offsets)
        storeKeywords()
    }
    
    public func addKeywords(_ newKeywords: [Keyword]) {
        let uniqueNewKeywords = newKeywords.filter { !$0.existsIn(keywords) }
        keywords.append(contentsOf: uniqueNewKeywords)
        storeKeywords()
        updateStatistics()
    }
    
    private func storeKeywords() {
        let keywords = keywords.map { keyword in
            return keyword.keyword
        }
        UserDefaults.standard.set(keywords, forKey: KeywordsViewModel.userDefaultsKey)
    }
    
    private func updateStatistics() {
        Task {
            do {
                keywords = try await Keyword.updateStatistics(keywords: keywords, region: "US")
            } catch {
                print("Failed fetching statistics: \(error)")
            }
        }
    }
    
    private var shouldFetchStatistics: Bool {
        for keyword in keywords {
            if keyword.popularity == nil {
                return true
            }
        }
        return false
    }
}
