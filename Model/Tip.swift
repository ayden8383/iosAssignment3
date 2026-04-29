//
//  Tip.swift
//
//  Use this model for a user's tip/pick for a match.
//  Store the selected team, lock status, and any future tip-related data here.

import Foundation

struct Tip: Identifiable, Hashable {
    let id: UUID
    let match: Match
    let selectedTeam: Team?
    let isLocked: Bool

    init(id: UUID = UUID(), match: Match, selectedTeam: Team? = nil, isLocked: Bool = false) {
        self.id = id
        self.match = match
        self.selectedTeam = selectedTeam
        self.isLocked = isLocked
    }
}
