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
    @State private var shouldPresentAddKeywordsAlert = false
    @State private var addKeywordText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.keywords, id: \.keyword) { keyword in
                    KeywordView(keyword: keyword)
                }
                .onDelete { offsets in
                    let keyword = viewModel.keywords[offsets.first!]
                    viewModel.removeKeyword(keyword)
                }
            }
            .searchable(text: $filterQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Filter")
                .onChange(of: filterQuery) { search in
                    //viewModel.filterQuery = filterQuery
                }
                .disableAutocorrection(true)
                .autocapitalization(.none)
            .navigationTitle("Keywords")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        shouldPresentAddKeywordsAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Add keyword", isPresented: $shouldPresentAddKeywordsAlert, actions: {
                TextField("Keyword", text: $addKeywordText)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                Button("Cancel", role: .cancel, action: {})
                Button("Add", action: {
                    if addKeywordText.count > 0 {
                        let keyword = Keyword(keyword: addKeywordText)
                        viewModel.addKeyword(keyword)
                        addKeywordText = ""
                    }
                })
            })
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
