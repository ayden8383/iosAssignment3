//
//  DataAPI.swift
//
//  Loads current NRL draw data from the public NRL.com draw feed.
//

import Foundation

struct LoadedNRLData {
    let matches: [Match]
    let tips: [Tip]
    let matchStats: [MatchStats]
}

enum DataAPI {
    private static let competitionId = 111
    private static let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15"

    static func fetchCurrentRoundData(season: Int = 2026) async throws -> LoadedNRLData {
        let urlString = "https://www.nrl.com/draw//data?competition=\(competitionId)&season=\(season)"
        guard let url = URL(string: urlString) else {
            throw DataAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw DataAPIError.badResponse
        }

        let decoded = try JSONDecoder().decode(NRLDrawResponse.self, from: data)
        let round = decoded.selectedRoundId ?? decoded.currentRoundNumber ?? 1
        let matches = decoded.fixtures
            .filter { $0.type == "Match" && $0.isCurrentRound == true }
            .map { $0.toMatch(round: round) }

        guard !matches.isEmpty else {
            throw DataAPIError.noCurrentRoundMatches
        }

        return LoadedNRLData(
            matches: matches,
            tips: matches.map { Tip(match: $0) },
            matchStats: matches
                .filter { $0.homeScore != nil && $0.awayScore != nil }
                .map { MatchStats(match: $0) }
        )
    }
}

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

private struct NRLDrawResponse: Decodable {
    let fixtures: [NRLFixture]
    let selectedRoundId: Int?

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

private struct NRLFixture: Decodable {
    let isCurrentRound: Bool?
    let roundTitle: String?
    let type: String
    let homeTeam: NRLTeam
    let awayTeam: NRLTeam
    let clock: NRLClock?

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

private struct NRLTeam: Decodable {
    let teamId: Int?
    let nickName: String
    let score: Int?
    let theme: NRLTheme?

    func toTeam() -> Team {
        Team(
            id: stableUUID(from: teamId),
            name: nickName,
            abbreviation: Self.abbreviations[nickName] ?? String(nickName.prefix(3)).uppercased(),
            logoURL: theme?.badgeURL
        )
    }

    private func stableUUID(from teamId: Int?) -> UUID {
        guard let teamId else {
            return UUID()
        }

        let suffix = String(format: "%012d", teamId)
        return UUID(uuidString: "00000000-0000-0000-0000-\(suffix)") ?? UUID()
    }

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

private struct NRLTheme: Decodable {
    let key: String
    let logos: [String: String]

    var badgeURL: URL? {
        let preferredLogoNames = [
            "badge-light.png",
            "badge.png",
            "badge-basic24.svg"
        ]

        for logoName in preferredLogoNames {
            if let version = logos[logoName] {
                return URL(string: "https://www.nrl.com/.theme/\(key)/\(logoName)?bust=\(version)")
            }
        }

        return nil
    }
}

private struct NRLClock: Decodable {
    let kickOffTimeLong: String?

    var kickOffDate: Date? {
        guard let kickOffTimeLong else {
            return nil
        }

        return ISO8601DateFormatter().date(from: kickOffTimeLong)
    }
}
