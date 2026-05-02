//
//  ScoreboardEntry.swift
//
//  Use this model for one row on the scoreboard/ladder.
//  Store user ranking data here, such as name, rank, correct tips, and total tips.

import Foundation

import Foundation

struct ScoreboardEntry: Identifiable, Hashable {
    let id = UUID()
    let rank: Int
    let name: String
    let correctTips: Int
    let totalTips: Int

    var percentage: Double {
        if totalTips == 0 {
            return 0
        }
        return Double(correctTips) / Double(totalTips)
    }
    
    
}
