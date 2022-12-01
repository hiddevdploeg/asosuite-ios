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
    private var allKeywords: [Keyword] {
        willSet {
            filter()
        }
    }
    
    public var filterQuery: String = "" {
        willSet {
            filter()
        }
    }
    
    init(keywords: [Keyword]? = nil) {
        if let keywords {
            self.allKeywords = keywords
            self.keywords = self.allKeywords
        } else {
            let allKeywords = UserDefaults.standard.stringArray(forKey: KeywordsViewModel.userDefaultsKey) ?? []
            self.allKeywords = allKeywords.map { keyword in
                return Keyword(keyword: keyword)
            }
            self.keywords = self.allKeywords
            fetchStatistics()
        }
    }
    
    private func filter() {
        if filterQuery.count == 0 {
            keywords = allKeywords
        } else {
            keywords = allKeywords.filter({ $0.keyword.localizedCaseInsensitiveContains(filterQuery) })
        }
    }
    
    public func removeKeyword(_ keyword: Keyword) {
        allKeywords.removeAll(where: { $0.keyword.localizedCaseInsensitiveContains(keyword.keyword) })
        filter()
        storeKeywords()
    }
    
    public func addKeyword(_ newKeyword: Keyword) {
        if allKeywords.contains(where: { $0.keyword.localizedCaseInsensitiveContains(newKeyword.keyword) }) {
            return
        }
        allKeywords.append(newKeyword)
        filter()
        storeKeywords()
        fetchStatistics()
    }
    
    private func storeKeywords() {
        let keywords = allKeywords.map { keyword in
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
