//
//  Team.swift
//
//  Use this model for an NRL team.
//  Add team display data here later, such as colours, logo names, or home ground details.

import Foundation

struct Team: Identifiable, Hashable {
    let id: UUID
    let name: String
    let abbreviation: String
    let logoURL: URL?

    init(id: UUID = UUID(), name: String, abbreviation: String, logoURL: URL? = nil) {
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
        self.logoURL = logoURL
    }
}
