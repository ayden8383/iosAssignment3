//
//  ScoreboardViewModel.swift
//
//  Use this view model for the Scoreboard page.
//  Put ladder entries, rankings, head-to-head data, and scoreboard actions here.

import Combine
import Foundation

final class ScoreboardViewModel: ObservableObject {
    @Published var entries: [ScoreboardEntry]

    init(entries: [ScoreboardEntry] = []) {
        self.entries = entries
    }
}
