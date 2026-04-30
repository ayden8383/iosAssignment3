//
//  SampleData.swift
//
//  Use this file for temporary MVP data while there is no database or API.
//  Replace or remove this later when real app data is loaded from storage or a network service.

import Foundation

enum SampleData {
    static let storm = Team(name: "Melbourne Storm", abbreviation: "MEL")
    static let rabbitohs = Team(name: "South Sydney Rabbitohs", abbreviation: "SSG")
    static let panthers = Team(name: "Penrith Panthers", abbreviation: "PEN")
    static let broncos = Team(name: "Brisbane Broncos", abbreviation: "BRI")

    static let matches: [Match] = [
        Match(round: 8, homeTeam: storm, awayTeam: rabbitohs, homeScore: 18, awayScore: 12),
        Match(round: 8, homeTeam: panthers, awayTeam: broncos)
    ]

    static let tips: [Tip] = [
        Tip(match: matches[0], selectedTeam: storm, isLocked: true),
        Tip(match: matches[1], selectedTeam: nil)
    ]

    static let matchStats: [MatchStats] = [
        MatchStats(match: matches[0], homeCompletionRate: 81, awayCompletionRate: 74)
    ]

    static let scoreboard: [ScoreboardEntry] = [
        ScoreboardEntry(rank: 1, name: "Chris", tipsCorrect: 52, totalTips: 56),
        ScoreboardEntry(rank: 2, name: "Alex", tipsCorrect: 50, totalTips: 54)
    ]
}
