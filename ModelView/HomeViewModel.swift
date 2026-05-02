//
//  HomeViewModel.swift
//
//  Home page computed properties on AppViewModel.

import Foundation

extension AppViewModel {
    var completedMatches: [Match] {
        matches.filter { $0.homeScore != nil && $0.awayScore != nil }
    }

    var upcomingMatches: [Match] {
        matches.filter { $0.homeScore == nil || $0.awayScore == nil }
    }

    var tipsCorrect: Int {
        tips.filter { tip in
            guard let selected = tip.selectedTeam,
                  let homeScore = tip.match.homeScore,
                  let awayScore = tip.match.awayScore else { return false }
            let winner = homeScore > awayScore ? tip.match.homeTeam : tip.match.awayTeam
            return selected.id == winner.id
        }.count
    }

    var tipProgress: Double {
        guard !matches.isEmpty else { return 0 }
        return Double(tipsPlaced) / Double(matches.count)
    }
}
