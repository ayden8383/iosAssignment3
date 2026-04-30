//
//  AppTab.swift
//
//  Use this file for the main tabs/pages in the app.
//  Add new cases here if the app gets more root-level pages.

import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case tips
    case stats
    case scoreboard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .tips:
            return "Tips"
        case .stats:
            return "Stats"
        case .scoreboard:
            return "Scoreboard"
        }
    }
}
