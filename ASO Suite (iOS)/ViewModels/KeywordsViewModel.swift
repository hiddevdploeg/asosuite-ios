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
            fetchStatistics()
        }
    }
    
    public func removeKeyword(atOffsets offsets: IndexSet) {
        keywords.remove(atOffsets: offsets)
        storeKeywords()
    }
    
    public func addKeywords(_ newKeywords: [Keyword]) {
        let uniqueNewKeywords = newKeywords.filter { newKeyword in
            return !keywords.contains { existingKeyword in
                return existingKeyword.keyword.localizedCaseInsensitiveCompare(newKeyword.keyword) == .orderedSame
            }
        }
        if uniqueNewKeywords.count == 0 {
            return
        }
        keywords.append(contentsOf: uniqueNewKeywords)
        storeKeywords()
        fetchStatistics()
    }
    
    private func storeKeywords() {
        let keywords = keywords.map { keyword in
            return keyword.keyword
        }
        UserDefaults.standard.set(keywords, forKey: KeywordsViewModel.userDefaultsKey)
    }
    
    private func fetchStatistics() {
        Task {
            do {
                var attempts = 0
                while shouldFetchStatistics {
                    attempts += 1
                    keywords = try await Keyword.updateStatistics(keywords: keywords, region: "US")
                    if !shouldFetchStatistics {
                        break
                    }
                    try await Task.sleep(nanoseconds: (attempts == 1) ? 3_000_000_000 : (attempts == 2) ? 5_000_000_000 : 20_000_000_000)
                }
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
