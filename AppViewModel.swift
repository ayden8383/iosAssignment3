//
//  AppViewModel.swift

//
//  Created by DCS on 29/4/2026.
//
//  Single source of truth for shared app state.
//  Matches and tips live here so all pages stay in sync.



import Combine

import Foundation

final class AppViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var matches: [Match]
    @Published var tips: [Tip]
    @Published var isLoadingData = false
    @Published var dataErrorMessage: String?

    private var hasLoadedNRLData = false


    let statsViewModel: StatsViewModel
    let scoreboardViewModel: ScoreboardViewModel

    init() {
        self.matches = SampleData.matches
        self.tips = SampleData.tips

        self.statsViewModel = StatsViewModel(matches: SampleData.matches)
        self.scoreboardViewModel = ScoreboardViewModel(entries: SampleData.scoreboard)
    }

    @MainActor
    func loadNRLData() async {
        // Only load once when the app opens. This avoids repeating the same API call.
        guard !hasLoadedNRLData else { return }

        hasLoadedNRLData = true
        isLoadingData = true
        dataErrorMessage = nil

        do {
            // Ask DataAPI for real NRL data, then replace the fallback sample data.
            let loadedData = try await DataAPI.fetchCurrentRoundData()
            matches = loadedData.matches
            tips = loadedData.tips
            statsViewModel.matches = loadedData.matches
        } catch {
            // If the internet/API fails, keep using SampleData and save the error message.
            dataErrorMessage = error.localizedDescription
        }

        isLoadingData = false
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

