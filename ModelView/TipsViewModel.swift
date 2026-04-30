//
//  TipsViewModel.swift
//
//  Use this view model for the Tips page.
//  Put tip selection state, round progress, and save/update tip actions here.

import Combine
import Foundation

final class TipsViewModel: ObservableObject {
    @Published var matches: [Match]
    @Published var tips: [Tip]

    init(matches: [Match] = [], tips: [Tip] = []) {
        self.matches = matches
        self.tips = tips
    }
}
