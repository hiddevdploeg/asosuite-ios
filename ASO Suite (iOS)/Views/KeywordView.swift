//
//  KeywordView.swift
//  ASO Suite (iOS)
//
//  Created by Niels Mouthaan on 29/11/2022.
//

import SwiftUI
import ASOSuiteShared

struct KeywordView: View {
    
    let keyword: Keyword
    
    var body: some View {
        HStack {
            Text(keyword.keyword)
            Spacer()
            
            if let popularity = keyword.popularity {
                ZStack {
                    Circle()
                        .stroke(
                            Color(.tertiarySystemGroupedBackground),
                            lineWidth: 4
                        )
                    Circle()
                        .trim(from: 0, to: CGFloat(popularity) / 100)
                        .stroke(
                            Color(score: popularity),
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 20, height: 20)
            } else {
                ProgressView()
            }
        }
    }
}

struct KeywordView_Previews: PreviewProvider {
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
