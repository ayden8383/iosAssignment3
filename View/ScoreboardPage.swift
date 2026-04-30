//
//  ScoreboardPage.swift
//
//  Use this file for the Scoreboard screen UI.
//  This page should eventually show the ladder, rankings, head-to-head section, and league snapshot.
//  Keep ranking data and actions in ScoreboardViewModel.

import SwiftUI

struct ScoreboardPage: View {
    @ObservedObject var viewModel: ScoreboardViewModel

    var body: some View {
        VStack {
            Text("Scoreboard")
            Text("\(viewModel.entries.count) entries loaded")
                .font(.caption)
        }
    }
}

#Preview {
    ScoreboardPage(viewModel: ScoreboardViewModel(entries: SampleData.scoreboard))
}
