//
//  HomeViewModel.swift
//
//  Use this view model for the Home page.
//  Put Home page state and actions here, such as live matches, upcoming fixtures, and weekly tip progress.

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var matches: [Match]
    @Published var tips: [Tip]

    init(matches: [Match] = [], tips: [Tip] = []) {
        self.matches = matches
        self.tips = tips
    }

    var currentRound: Int {
        matches.first?.round ?? 1
    }

    var completedMatches: [Match] {
        matches.filter { $0.homeScore != nil && $0.awayScore != nil }
    }

    var upcomingMatches: [Match] {
        matches.filter { $0.homeScore == nil || $0.awayScore == nil }
    }

    var tipsPlaced: Int {
        tips.filter { $0.selectedTeam != nil }.count
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

    func tip(for match: Match) -> Tip? {
        tips.first { $0.match.id == match.id }
    }
}
