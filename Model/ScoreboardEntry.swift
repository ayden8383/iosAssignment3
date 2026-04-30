//
//  ScoreboardEntry.swift
//
//  Use this model for one row on the scoreboard/ladder.
//  Store user ranking data here, such as name, rank, correct tips, and total tips.

import Foundation

struct ScoreboardEntry: Identifiable, Hashable {
    let id: UUID
    let rank: Int
    let name: String
    let tipsCorrect: Int
    let totalTips: Int

    init(id: UUID = UUID(), rank: Int, name: String, tipsCorrect: Int, totalTips: Int) {
        self.id = id
        self.rank = rank
        self.name = name
        self.tipsCorrect = tipsCorrect
        self.totalTips = totalTips
    }
}
