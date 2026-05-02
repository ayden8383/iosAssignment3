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


    var sortedEntries: [ScoreboardEntry] {
        return entries.sorted { a, b in
            if a.correctTips > b.correctTips {
                return true
            } else if a.correctTips < b.correctTips {
                return false
            } else {
                return a.percentage > b.percentage
            }
        }
        
    }
    var highestScore: Int {
        return sortedEntries.first?.correctTips ?? 0
    }
   
    var leader: ScoreboardEntry? {
        if sortedEntries.count > 0 {
            return sortedEntries[0]
        }
        return nil
        
    }
}
