//
//  KeywordView.swift
//  ASO Suite (iOS)
//
//  Created by Niels Mouthaan on 29/11/2022.
//

import SwiftUI

struct KeywordView: View {
    
    let keyword: String
    
    var body: some View {
        HStack {
            Text(keyword)
            Spacer()
            ZStack {
                Circle()
                    .stroke(
                        Color(.tertiarySystemGroupedBackground),
                        lineWidth: 3
                    )
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(
                        Color.green,
                        style: StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 15, height: 15)
        }
    }
}

struct KeywordView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordView(keyword: "time tracker")
    }
}
