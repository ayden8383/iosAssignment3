//
//  StatsPage.swift
//
//  Use this file for the Stats screen UI.
//  This page should eventually show match scores, at-a-glance stats, recent form, and team comparison.
//  Keep stat data and calculations in StatsViewModel.

import SwiftUI

struct StatsPage: View {
    @ObservedObject var viewModel: StatsViewModel

    var body: some View {
        VStack {
            Text("Stats")
            Text("\(viewModel.stats.count) stat records loaded")
                .font(.caption)
        }
    }
}

#Preview {
    StatsPage(viewModel: StatsViewModel(stats: SampleData.matchStats))
}
