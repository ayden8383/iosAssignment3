//
//  MatchStats.swift
//
//  Use this model for the stats attached to a match.
//  Add fields here later for tries, metres, possession, completion rate, or any other match stat.

import Foundation

struct MatchStats: Identifiable, Hashable {
    let id: UUID
    let match: Match
    let homeCompletionRate: Int?
    let awayCompletionRate: Int?

    init(
        id: UUID = UUID(),
        match: Match,
        homeCompletionRate: Int? = nil,
        awayCompletionRate: Int? = nil
    ) {
        self.id = id
        self.match = match
        self.homeCompletionRate = homeCompletionRate
        self.awayCompletionRate = awayCompletionRate
    }
}
