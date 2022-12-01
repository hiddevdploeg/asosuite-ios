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
    
    private var allKeywords: [Keyword] {
        didSet {
            filter()
        }
    }
    @Published public private(set) var keywords: [Keyword]
    
    public var filterQuery: String = "" {
        didSet {
            filter()
        }
    }
    
    init(keywords: [Keyword]? = nil) {
        if let keywords {
            self.allKeywords = keywords
            self.keywords = self.allKeywords
        } else {
            let allKeywords = UserDefaults.standard.stringArray(forKey: KeywordsViewModel.userDefaultsKey) ?? []
            self.allKeywords = allKeywords.map {keyword in
                return Keyword(keyword: keyword)
            }
            self.keywords = self.allKeywords
            fetchStatistics()
        }
    }
    
    public func removeKeyword(atOffsets offsets: IndexSet) {
        self.keywords.remove(atOffsets: offsets)
        storeKeywords()
    }
    
    public func addKeyword(_ keyword: Keyword) {
        self.keywords.append(keyword)
        storeKeywords()
        fetchStatistics()
    }
    
    private func storeKeywords() {
        let keywords = self.keywords.map { keyword in
            return keyword.keyword
        }
        UserDefaults.standard.set(keywords, forKey: KeywordsViewModel.userDefaultsKey)
    }
    
    private func filter() {
        if filterQuery.count == 0 {
            self.keywords = self.allKeywords
        } else {
            self.keywords = self.allKeywords.filter({ $0.keyword.localizedCaseInsensitiveContains(self.filterQuery) })
        }
    }
    
    private func fetchStatistics() {
        Task {
            do {
                var attempts = 0
                while !Keyword.hasAllStatistics(keywords: self.keywords) {
                    attempts += 1
                    self.allKeywords = try await Keyword.updateStatistics(keywords: self.keywords, region: "US")
                    try await Task.sleep(nanoseconds: (attempts == 1) ? 3_000_000_000 : (attempts == 2) ? 5_000_000_000 : 20_000_000_000)
                }
            } catch {
                print("Failed fetching statistics: \(error.localizedDescription)")
            }
        }
    }
}
