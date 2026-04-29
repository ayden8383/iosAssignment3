//
//  HomeViewModel.swift
//
//  Use this view model for the Home page.
//  Put Home page state and actions here, such as live matches, upcoming fixtures, and weekly tip progress.

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    @Published var matches: [Match]
    @Published var tips: [Tip]

    init(matches: [Match] = [], tips: [Tip] = []) {
        self.matches = matches
        self.tips = tips
    }
}
