//
//  Match.swift
//
//  Use this model for one NRL match/fixture.
//  Store match details here, such as teams, round number, date, and scores.

import Foundation

struct Match: Identifiable, Hashable {
    let id: UUID
    let round: Int
    let homeTeam: Team
    let awayTeam: Team
    let scheduledDate: Date?
    let homeScore: Int?
    let awayScore: Int?

    init(
        id: UUID = UUID(),
        round: Int,
        homeTeam: Team,
        awayTeam: Team,
        scheduledDate: Date? = nil,
        homeScore: Int? = nil,
        awayScore: Int? = nil
    ) {
        self.id = id
        self.round = round
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.scheduledDate = scheduledDate
        self.homeScore = homeScore
        self.awayScore = awayScore
    }
}
