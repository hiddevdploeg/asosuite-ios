//
//  AddKeywordsView.swift
//  ASO Suite (iOS)
//
//  Created by Niels Mouthaan on 29/11/2022.
//

import SwiftUI
import Combine
import ASOSuiteShared

struct AddKeywordsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: KeywordsViewModel
    @State private var newKeyword = ""
    @FocusState private var textFieldIsFocussed: Bool
    @State private var keywords: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            TextField("keyword", text: $newKeyword)
                                .onSubmit {
                                    addKeyword()
                                }
                                .onReceive(Just(newKeyword)) { newValue in
                                    let filtered = Keyword.filterIllegalCharacters(newKeyword)
                                    if Keyword.filterIllegalCharacters(newKeyword) != newValue {
                                        newKeyword = filtered
                                    }
                                }
                                .focused($textFieldIsFocussed)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .submitLabel(.done)
                            Spacer()
                            Button {
                                addKeyword()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 3)
                        LazyVStack {
                            ForEach(keywords, id: \.self) { keyword in
                                HStack {
                                    Text(keyword)
                                    Spacer()
                                    Button {
                                        keywords.removeAll(where: {$0 == keyword})
                                    } label: {
                                        Image(systemName: "minus")
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
            }
            .navigationTitle("Add keywords")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel", action: {
                textFieldIsFocussed = false
                dismiss()
            }), trailing: Button("Done", action: {
                let newKeywords = keywords.map({ return Keyword(keyword: $0) })
                viewModel.addKeywords(newKeywords)
                textFieldIsFocussed = false
                dismiss()
            }).disabled(keywords.count == 0))
        }
        .onAppear {
            textFieldIsFocussed = true
        }
    }
    
    private func addKeyword() {
         let lowercasedKeyword = newKeyword.lowercased()
         if lowercasedKeyword.count > 0 && !keywords.contains(lowercasedKeyword) {
             keywords.append(lowercasedKeyword)
             newKeyword = ""
             textFieldIsFocussed = true
         }
    }
}

struct AddKeywordsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KeywordsViewModel(keywords: [])
        AddKeywordsView(viewModel: viewModel)
    }
}
