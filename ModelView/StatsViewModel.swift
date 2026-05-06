//
//  StatsViewModel.swift
//
//  Use this view model for the Stats page.
//  Put selected match stats, stat summaries, and any stats filtering logic here.

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

    var totalStatRecords: Int {
        stats.count
    }

    var completedMatches: [MatchStats] {
        stats.filter { stat in
            stat.match.homeScore != nil && stat.match.awayScore != nil
        }
    }

    var averageHomeCompletionRate: Int {
        let rates = stats.compactMap { $0.homeCompletionRate }
        guard !rates.isEmpty else { return 0 }

        return rates.reduce(0, +) / rates.count
    }

    var averageAwayCompletionRate: Int {
        let rates = stats.compactMap { $0.awayCompletionRate }
        guard !rates.isEmpty else { return 0 }

        return rates.reduce(0, +) / rates.count
    }

    var highestScoringMatch: MatchStats? {
        completedMatches.max { first, second in
            let firstTotal = (first.match.homeScore ?? 0) + (first.match.awayScore ?? 0)
            let secondTotal = (second.match.homeScore ?? 0) + (second.match.awayScore ?? 0)

            return firstTotal < secondTotal
        }
    }
}
