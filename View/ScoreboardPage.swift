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
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Scoreboard")
                    .font(.largeTitle)
                    .bold()

                if let leader = viewModel.leader {
                    Text("Current Leader: \(leader.name)")
                        .font(.headline)

                    Text("\(leader.correctTips) / \(leader.totalTips) correct tips")
                        .font(.caption)
                        .bold()
                }

                List(viewModel.sortedEntries) { entry in
                    HStack {
                        Text("#\(entry.rank)")
                            .frame(width: 45, alignment: .leading)

                        VStack(alignment: .leading) {
                            Text(entry.name)
                                .font(.headline)

                            Text("\(entry.correctTips) of \(entry.totalTips) correct tips")
                                .font(.caption)
                        }
                        Spacer()

                        Text("\(Int(entry.percentage * 100))%")
                            .font(.headline)
                    }
                    .padding(.vertical, 6)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ScoreboardPage(viewModel: ScoreboardViewModel(entries: SampleData.scoreboard))
}
