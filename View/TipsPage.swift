//
//  TipsPage.swift
//
//  Use this file for the Tips screen UI.
//  This page should eventually show match tip choices, selected winners, odds, and round progress.
//  Keep tip state and update logic in TipsViewModel.

import SwiftUI

struct TipsPage: View {
    @ObservedObject var viewModel: TipsViewModel

    var body: some View {
        VStack {
            Text("Tips")
            Text("\(viewModel.tips.count) tips loaded")
                .font(.caption)
        }
    }
}

#Preview {
    TipsPage(viewModel: TipsViewModel(matches: SampleData.matches, tips: SampleData.tips))
}
