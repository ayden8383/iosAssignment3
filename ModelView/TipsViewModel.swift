//
//  TipsViewModel.swift
//
//  Tips page actions on AppViewModel.

import Foundation

extension AppViewModel {
    var allTipsLocked: Bool {
        tips.allSatisfy { $0.isLocked || ($0.match.homeScore != nil) }
    }

    func selectTeam(_ team: Team, for match: Match) {
        guard let index = tips.firstIndex(where: { $0.match.id == match.id }) else { return }
        guard !tips[index].isLocked else { return }
        guard match.homeScore == nil else { return }
        tips[index].selectedTeam = team
        saveTips()
    }

    func lockTip(for match: Match) {
        guard let index = tips.firstIndex(where: { $0.match.id == match.id }) else { return }
        guard tips[index].selectedTeam != nil, !tips[index].isLocked else { return }
        tips[index].isLocked = true
        saveTips()
    }

    func unlockTip(for match: Match) {
        guard let index = tips.firstIndex(where: { $0.match.id == match.id }) else { return }
        guard match.homeScore == nil else { return }
        tips[index].isLocked = false
        saveTips()
    }

    func lockAllTips() {
        for i in tips.indices where tips[i].selectedTeam != nil && !tips[i].isLocked {
            tips[i].isLocked = true
        }
        saveTips()
    }
}
