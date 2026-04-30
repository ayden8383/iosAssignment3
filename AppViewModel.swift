//
//  AppViewModel.swift
//  
//
//  Created by DCS on 29/4/2026.
//
//  Use this file for shared app-level state.
//  This is where the main app view models are created and passed into the pages.
//  Keep screen-specific logic inside the individual view model files.

import Combine
import Foundation

final class AppViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home

    let homeViewModel: HomeViewModel
    let tipsViewModel: TipsViewModel
    let statsViewModel: StatsViewModel
    let scoreboardViewModel: ScoreboardViewModel

    init() {
        let matches = SampleData.matches
        let tips = SampleData.tips

        self.homeViewModel = HomeViewModel(matches: matches, tips: tips)
        self.tipsViewModel = TipsViewModel(matches: matches, tips: tips)
        self.statsViewModel = StatsViewModel(stats: SampleData.matchStats)
        self.scoreboardViewModel = ScoreboardViewModel(entries: SampleData.scoreboard)
    }
}

