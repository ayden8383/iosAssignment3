//
//  SampleData.swift
//
//  Fallback and preview data used when NRL API data is unavailable.

import Foundation

enum SampleData {
    static let storm = Team(name: "Melbourne Storm", abbreviation: "MEL")
    static let rabbitohs = Team(name: "South Sydney Rabbitohs", abbreviation: "SOU")
    static let panthers = Team(name: "Penrith Panthers", abbreviation: "PEN")
    static let broncos = Team(name: "Brisbane Broncos", abbreviation: "BRI")
    static let roosters = Team(name: "Sydney Roosters", abbreviation: "SYD")
    static let bulldogs = Team(name: "Canterbury Bulldogs", abbreviation: "CBY")
    static let raiders = Team(name: "Canberra Raiders", abbreviation: "CAN")
    static let sharks = Team(name: "Cronulla Sharks", abbreviation: "CRO")

    private static func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        var c = DateComponents()
        c.year = year; c.month = month; c.day = day; c.hour = hour; c.minute = minute
        c.timeZone = TimeZone(identifier: "Australia/Sydney")
        return Calendar.current.date(from: c) ?? Date()
    }

    static let matches: [Match] = [
        Match(round: 8, homeTeam: storm, awayTeam: rabbitohs,
              scheduledDate: date(2026, 5, 1, 19, 50), homeScore: 24, awayScore: 12),
        Match(round: 8, homeTeam: roosters, awayTeam: bulldogs,
              scheduledDate: date(2026, 5, 1, 21, 0), homeScore: 18, awayScore: 22),
        Match(round: 8, homeTeam: panthers, awayTeam: broncos,
              scheduledDate: date(2026, 5, 2, 17, 30)),
        Match(round: 8, homeTeam: raiders, awayTeam: sharks,
              scheduledDate: date(2026, 5, 2, 19, 50)),
    ]

    static let tips: [Tip] = [
        Tip(match: matches[0], selectedTeam: storm, isLocked: true),
        Tip(match: matches[1], selectedTeam: roosters, isLocked: true),
        Tip(match: matches[2], selectedTeam: panthers),
        Tip(match: matches[3], selectedTeam: nil),
    ]

    static let matchStats: [MatchStats] = [
        MatchStats(match: matches[0], homeCompletionRate: 81, awayCompletionRate: 74)
    ]

    static let scoreboard: [ScoreboardEntry] = [
        ScoreboardEntry(rank: 1, name: "Chris", correctTips: 52, totalTips: 56),
        ScoreboardEntry(rank: 2, name: "Alex", correctTips: 50, totalTips: 56),
        ScoreboardEntry(rank: 2, name: "Bob", correctTips: 46, totalTips: 56)
    ]
}
