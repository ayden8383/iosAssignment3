//
//  HomePage.swift
//
//  Use this file for the Home screen UI.
//  This page should eventually show the current round, live match, upcoming fixtures, and this week's tip summary.
//  Keep data and business logic in HomeViewModel.

import SwiftUI

struct HomePage: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            Text("Home")
            Text("\(viewModel.matches.count) matches loaded")
                .font(.caption)
        }
    }
}

#Preview {
    HomePage(viewModel: HomeViewModel(matches: SampleData.matches, tips: SampleData.tips))
}
