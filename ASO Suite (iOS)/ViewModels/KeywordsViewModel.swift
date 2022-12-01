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
            self.keywords = keywords.map {keyword in
                return Keyword(keyword: keyword)
            }
            fetchStatistics()
        }
    }
    
    public func removeKeyword(atOffsets offsets: IndexSet) {
        self.keywords.remove(atOffsets: offsets)
        storeKeywords()
    }
    
    public func addKeyword(_ newKeyword: Keyword) {
        if self.keywords.contains(newKeyword) {
            return
        }
        self.keywords.append(newKeyword)
        storeKeywords()
        fetchStatistics()
    }
    
    private func storeKeywords() {
        let keywords = self.keywords.map { keyword in
            return keyword.keyword
        }
        UserDefaults.standard.set(keywords, forKey: KeywordsViewModel.userDefaultsKey)
    }
    
    private func fetchStatistics() {
        Task {
            do {
                var attempts = 0
                while !Keyword.hasAllStatistics(keywords: self.keywords) {
                    attempts += 1
                    self.keywords = try await Keyword.updateStatistics(keywords: self.keywords, region: "US")
                    try await Task.sleep(nanoseconds: (attempts == 1) ? 3_000_000_000 : (attempts == 2) ? 5_000_000_000 : 20_000_000_000)
                }
            } catch {
                print("Failed fetching statistics: \(error)")
            }
        }
    }
}
