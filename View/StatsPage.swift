//
//  StatsPage.swift
//
//  Use this file for the Stats screen UI.
//  This page should eventually show match scores, at-a-glance stats, recent form, and team comparison.
//  Keep stat data and calculations in StatsViewModel.

import SwiftUI

struct StatsPage: View {
    @ObservedObject var viewModel: StatsViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Stats")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    summarySection

                    matchStatsSection
                }
                .padding()
            }
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Summary")
                .font(.headline)

            HStack(spacing: 12) {
                StatCard(
                    title: "Stat Records",
                    value: "\(viewModel.totalStatRecords)"
                )

                StatCard(
                    title: "Completed Matches",
                    value: "\(viewModel.completedMatches.count)"
                )
            }

            HStack(spacing: 12) {
                StatCard(
                    title: "Avg Home Completion",
                    value: "\(viewModel.averageHomeCompletionRate)%"
                )

                StatCard(
                    title: "Avg Away Completion",
                    value: "\(viewModel.averageAwayCompletionRate)%"
                )
            }
        }
    }

    private var matchStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Match Stats")
                .font(.headline)

            if viewModel.stats.isEmpty {
                Text("No stats available yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.stats) { stat in
                    MatchStatRow(stat: stat)
                }
            }
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

private struct MatchStatRow: View {
    let stat: MatchStats

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Round \(stat.match.round)")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text("\(stat.match.homeTeam.name) vs \(stat.match.awayTeam.name)")
                .font(.headline.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))

            if let homeScore = stat.match.homeScore,
               let awayScore = stat.match.awayScore {
                Text("Score: \(homeScore) - \(awayScore)")
                    .font(.headline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.8))
            } else {
                Text("Match not completed")
                    .font(.headline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.8))
            }

            HStack {
                Text("\(stat.match.homeTeam.abbreviation): \(stat.homeCompletionRate ?? 0)%")
                Spacer()
                Text("\(stat.match.awayTeam.abbreviation): \(stat.awayCompletionRate ?? 0)%")
            }
            .font(.headline.weight(.medium))
            .foregroundStyle(.white.opacity(0.8))
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(red: 0.06, green: 0.30, blue: 0.18),
                         Color(red: 0.10, green: 0.52, blue: 0.30)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
    }
}

#Preview {
    StatsPage(viewModel: StatsViewModel(stats: SampleData.matchStats))
}
