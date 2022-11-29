//
//  ContentView.swift
//  ASO Suite (iOS)
//
//  Created by Niels Mouthaan on 29/11/2022.
//

import SwiftUI

struct KeywordsView: View {
    
    @State private var keywords = ["hour tracker", "hours tracker", "time tracker", "time tracking"] //TODO: Make dynamic
    @State private var filterText = ""
    @State private var shouldPresentAddKeywordsAlert = false
    @State private var addKeywordText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(keywords, id: \.self) { keyword in
                    KeywordView(keyword: keyword)
                }
                .onDelete(perform: deleteKeyword)
            }
            .searchable(text: $filterText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Filter")
                .onChange(of: filterText) { search in
                    // TODO
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
                    addKeyword()
                })
            })
        }
    }
    
    func addKeyword() {
        //TODO: Validate
        //TODO: Persist
    }
    
    func deleteKeyword(at offsets: IndexSet) {
        keywords.remove(atOffsets: offsets)
    }
}

struct KeywordsView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordsView()
    }
}
