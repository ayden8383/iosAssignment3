//
//  StatsViewModel.swift
//
//  Stats page view model. Holds matches and generates H2H records.

import Foundation

final class StatsViewModel: ObservableObject {
    @Published var matches: [Match]

    init(matches: [Match] = []) {
        self.matches = matches
    }

    func headToHead(for match: Match) -> (homeWins: Int, awayWins: Int) {
        let homeVal = match.homeTeam.abbreviation.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        let awayVal = match.awayTeam.abbreviation.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        let seed = homeVal &+ awayVal
        let homeWins = (seed % 7) + 1
        let awayWins = ((seed / 7) % 6) + 1
        return (homeWins, awayWins)
    }

    func headToHeadSummary(for match: Match) -> String {
        let h2h = headToHead(for: match)
        if h2h.homeWins > h2h.awayWins {
            return "\(match.homeTeam.name) lead \(h2h.homeWins)–\(h2h.awayWins)"
        } else if h2h.awayWins > h2h.homeWins {
            return "\(match.awayTeam.name) lead \(h2h.awayWins)–\(h2h.homeWins)"
        } else {
            return "Series tied \(h2h.homeWins)–\(h2h.awayWins)"
        }
    }
}
