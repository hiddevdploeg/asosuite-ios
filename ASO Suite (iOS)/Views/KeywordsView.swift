//
//  ContentView.swift
//  ASO Suite (iOS)
//
//  Created by Niels Mouthaan on 29/11/2022.
//

import SwiftUI
import ASOSuiteShared

struct KeywordsView: View {
    
    @ObservedObject var viewModel: KeywordsViewModel
    @State private var filterQuery = ""
    @State private var showingAddKeywordsSheet = false
    @State private var addKeywordText = ""
    
    private var filteredKeywords: [Keyword] {
        if filterQuery.count == 0 {
            return viewModel.keywords
        } else {
            return viewModel.keywords.filter({ $0.keyword.localizedCaseInsensitiveContains(filterQuery) })
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredKeywords, id: \.keyword) { keyword in
                    KeywordView(keyword: keyword)
                }
                .onDelete { offsets in
                    viewModel.removeKeyword(atOffsets: offsets)
                }
            }
            .searchable(text: $filterQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Filter")
                .disableAutocorrection(true)
                .autocapitalization(.none)
            .navigationTitle("Keywords")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddKeywordsSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddKeywordsSheet) {
                AddKeywordsView(viewModel: viewModel)
                    .interactiveDismissDisabled(true)
            }
        }
    }
}

struct KeywordsView_Previews: PreviewProvider {
    static var previews: some View {
        let keyword1 = Keyword(keyword: "christmas", popularity: 5)
        let keyword2 = Keyword(keyword: "new years eve", popularity: 25)
        let keyword3 = Keyword(keyword: "valentines day", popularity: 50)
        let keyword4 = Keyword(keyword: "eastern", popularity: 75)
        let keyword5 = Keyword(keyword: "thanksgiving")
        let viewModel = KeywordsViewModel(keywords: [keyword1, keyword2, keyword3, keyword4, keyword5])
        KeywordsView(viewModel: viewModel)
    }
}
