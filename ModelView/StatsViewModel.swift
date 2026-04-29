//
//  StatsViewModel.swift
//
//  Use this view model for the Stats page.
//  Put selected match stats, stat summaries, and any stats filtering logic here.

import Combine
import Foundation

final class StatsViewModel: ObservableObject {
    @Published var stats: [MatchStats]

    init(stats: [MatchStats] = []) {
        self.stats = stats
    }
}
