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

        restoreSavedTips()
    }

    @MainActor
    func loadNRLData() async {
        guard !hasLoadedNRLData else { return }

        hasLoadedNRLData = true
        isLoadingData = true
        dataErrorMessage = nil

        do {
            let loadedData = try await DataAPI.fetchCurrentRoundData()
            matches = loadedData.matches
            tips = loadedData.tips
            statsViewModel.matches = loadedData.matches
            restoreSavedTips()
        } catch {
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

    // MARK: - Tip Persistence

    private static let tipsKey = "savedTipSelections"

    func saveTips() {
        let saved = tips.compactMap { tip -> SavedTipSelection? in
            guard tip.selectedTeam != nil || tip.isLocked else { return nil }
            return SavedTipSelection(
                homeTeamName: tip.match.homeTeam.name,
                awayTeamName: tip.match.awayTeam.name,
                round: tip.match.round,
                selectedTeamName: tip.selectedTeam?.name,
                isLocked: tip.isLocked
            )
        }
        if let data = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(data, forKey: Self.tipsKey)
        }
    }

    private func restoreSavedTips() {
        guard let data = UserDefaults.standard.data(forKey: Self.tipsKey),
              let saved = try? JSONDecoder().decode([SavedTipSelection].self, from: data) else { return }

        for selection in saved {
            guard let index = tips.firstIndex(where: {
                $0.match.homeTeam.name == selection.homeTeamName &&
                $0.match.awayTeam.name == selection.awayTeamName &&
                $0.match.round == selection.round
            }) else { continue }

            if let selectedName = selection.selectedTeamName {
                let match = tips[index].match
                if match.homeTeam.name == selectedName {
                    tips[index].selectedTeam = match.homeTeam
                } else if match.awayTeam.name == selectedName {
                    tips[index].selectedTeam = match.awayTeam
                }
            }

            if selection.isLocked && tips[index].selectedTeam != nil {
                tips[index].isLocked = true
            }
        }
    }
}

private struct SavedTipSelection: Codable {
    let homeTeamName: String
    let awayTeamName: String
    let round: Int
    let selectedTeamName: String?
    let isLocked: Bool
}
