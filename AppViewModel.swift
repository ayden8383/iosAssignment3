//
//  AppViewModel.swift
//
//  Created by DCS on 29/4/2026.
//
//  Single source of truth for shared app state.
//  Matches and tips live here so all pages stay in sync.

<<<<<<< HEAD
import Combine
=======
>>>>>>> a5c795b9228f7e3e3b0a9e73f0009160ecf0e105
import Foundation

final class AppViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var matches: [Match]
    @Published var tips: [Tip]

    let statsViewModel: StatsViewModel
    let scoreboardViewModel: ScoreboardViewModel

    init() {
        self.matches = SampleData.matches
        self.tips = SampleData.tips
        self.statsViewModel = StatsViewModel(stats: SampleData.matchStats)
        self.scoreboardViewModel = ScoreboardViewModel(entries: SampleData.scoreboard)
    }

    var currentRound: Int {
        matches.first?.round ?? 1
    }

    var tipsPlaced: Int {
        tips.filter { $0.selectedTeam != nil }.count
    }

    func tip(for match: Match) -> Tip? {
        tips.first { $0.match.id == match.id }
    }
}
<<<<<<< HEAD

=======
>>>>>>> a5c795b9228f7e3e3b0a9e73f0009160ecf0e105
