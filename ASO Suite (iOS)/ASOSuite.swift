//
//  ASOSuite.swift
//  ASO Suite (iOS)
//
//  Created by Niels Mouthaan on 29/11/2022.
//

import SwiftUI

@main
struct ASOSuite: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = KeywordsViewModel()
            KeywordsView(viewModel: viewModel)
        }
    }
}
