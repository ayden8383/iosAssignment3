//
//  DataAPI.swift
//
//  Loads current NRL draw data from the public NRL.com draw feed.
//

import Foundation

// This is the final clean data that the rest of the app understands.
// The API sends a big JSON file, but the app only needs matches, tips, and stats.
struct LoadedNRLData {
    let matches: [Match]
    let tips: [Tip]
    let matchStats: [MatchStats]
}

enum DataAPI {
    // 111 is the NRL Telstra Premiership competition ID used by NRL.com.
    private static let competitionId = 111

    // NRL.com rejects some requests unless they look like they came from a browser/app.
    private static let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15"

    // Downloads the current NRL round and converts it into the app's own models.
    static func fetchCurrentRoundData(season: Int = 2026) async throws -> LoadedNRLData {
        let urlString = "https://www.nrl.com/draw//data?competition=\(competitionId)&season=\(season)"
        guard let url = URL(string: urlString) else {
            throw DataAPIError.invalidURL
        }

        // Add the headers NRL.com expects before asking for the JSON.
        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // This is the actual internet call. It returns raw JSON data.
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw DataAPIError.badResponse
        }

        // Turn the JSON into Swift structs, then keep only the current-round matches.
        let decoded = try JSONDecoder().decode(NRLDrawResponse.self, from: data)
        let round = decoded.selectedRoundId ?? decoded.currentRoundNumber ?? 1
        let matches = decoded.fixtures
            .filter { $0.type == "Match" && $0.isCurrentRound == true }
            .map { $0.toMatch(round: round) }

        guard !matches.isEmpty else {
            throw DataAPIError.noCurrentRoundMatches
        }

        // Each loaded match starts with an empty tip so the user can choose a team.
        // The draw API does not provide completion rates, so stats records are basic.
        return LoadedNRLData(
            matches: matches,
            tips: matches.map { Tip(match: $0) },
            matchStats: matches
                .filter { $0.homeScore != nil && $0.awayScore != nil }
                .map { MatchStats(match: $0) }
        )
    }
}

// These are the possible problems this file can report to the app.
enum DataAPIError: Error, LocalizedError {
    case invalidURL
    case badResponse
    case noCurrentRoundMatches

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The NRL draw URL could not be created."
        case .badResponse:
            return "The NRL draw API returned an invalid response."
        case .noCurrentRoundMatches:
            return "No current-round NRL matches were found."
        }
    }
}

// Matches the top-level JSON object returned by the NRL draw API.
private struct NRLDrawResponse: Decodable {
    let fixtures: [NRLFixture]
    let selectedRoundId: Int?

    // Backup way to find the round number if selectedRoundId is missing.
    var currentRoundNumber: Int? {
        fixtures
            .first(where: { $0.isCurrentRound == true })?
            .roundTitle
            .flatMap(Self.roundNumber(from:))
    }

    private static func roundNumber(from title: String) -> Int? {
        let digits = title.filter { $0.isNumber }
        return Int(digits)
    }
}

// One game from the NRL JSON. Later this becomes one Match in our app.
private struct NRLFixture: Decodable {
    let isCurrentRound: Bool?
    let roundTitle: String?
    let type: String
    let homeTeam: NRLTeam
    let awayTeam: NRLTeam
    let clock: NRLClock?

    // Converts the API's fixture format into the app's Match format.
    func toMatch(round: Int) -> Match {
        Match(
            round: round,
            homeTeam: homeTeam.toTeam(),
            awayTeam: awayTeam.toTeam(),
            scheduledDate: clock?.kickOffDate,
            homeScore: homeTeam.score,
            awayScore: awayTeam.score
        )
    }
}

// One team from the NRL JSON. This includes the score and logo information.
private struct NRLTeam: Decodable {
    let teamId: Int?
    let nickName: String
    let score: Int?
    let theme: NRLTheme?

    // Converts the API's team format into the app's Team format.
    func toTeam() -> Team {
        Team(
            id: stableUUID(from: teamId),
            name: nickName,
            abbreviation: Self.abbreviations[nickName] ?? String(nickName.prefix(3)).uppercased(),
            logoURL: theme?.badgeURL
        )
    }

    // The API gives teams number IDs. This turns that number into a stable UUID
    // so SwiftUI can tell that the same team is still the same team after reloads.
    private func stableUUID(from teamId: Int?) -> UUID {
        guard let teamId else {
            return UUID()
        }

        let suffix = String(format: "%012d", teamId)
        return UUID(uuidString: "00000000-0000-0000-0000-\(suffix)") ?? UUID()
    }

    // NRL.com gives team nicknames, but the app displays short abbreviations too.
    private static let abbreviations: [String: String] = [
        "Broncos": "BRI",
        "Bulldogs": "CBY",
        "Cowboys": "NQL",
        "Dolphins": "DOL",
        "Dragons": "STI",
        "Eels": "PAR",
        "Knights": "NEW",
        "Panthers": "PEN",
        "Rabbitohs": "SOU",
        "Raiders": "CAN",
        "Roosters": "SYD",
        "Sea Eagles": "MAN",
        "Sharks": "CRO",
        "Storm": "MEL",
        "Titans": "GLD",
        "Warriors": "WAR",
        "Wests Tigers": "WST"
    ]
}

// The theme object tells us where the team badge images live on NRL.com.
private struct NRLTheme: Decodable {
    let key: String
    let logos: [String: String]

    // Builds the full image URL from the theme key and logo version.
    // Example: dolphins + badge-light.png becomes an image link on nrl.com.
    var badgeURL: URL? {
        // Prefer PNG files because SwiftUI can display them reliably.
        let preferredLogoNames = [
            "badge-light.png",
            "badge.png",
            "badge-basic24.svg"
        ]

        // The "bust" value is a version number that helps NRL.com serve the latest image.
        for logoName in preferredLogoNames {
            if let version = logos[logoName] {
                return URL(string: "https://www.nrl.com/.theme/\(key)/\(logoName)?bust=\(version)")
            }
        }

        return nil
    }
}

// The clock object contains the kickoff date/time as text.
private struct NRLClock: Decodable {
    let kickOffTimeLong: String?

    // Converts the API's date text into a real Date that SwiftUI can format.
    var kickOffDate: Date? {
        guard let kickOffTimeLong else {
            return nil
        }

        return ISO8601DateFormatter().date(from: kickOffTimeLong)
    }
}
