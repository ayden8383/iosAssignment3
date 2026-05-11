//
//  StatsPage.swift
//
//  Shows each match in the round with head-to-head records.

import SwiftUI

struct StatsPage: View {
    @ObservedObject var viewModel: StatsViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.matches) { match in
                        matchH2HCard(match)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Stats")
        }
    }

    private func matchH2HCard(_ match: Match) -> some View {
        let h2h = viewModel.headToHead(for: match)
        let isCompleted = match.homeScore != nil && match.awayScore != nil

        return VStack(spacing: 12) {
            HStack {
                if isCompleted {
                    Text("FULL TIME")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if let date = match.scheduledDate {
                    Text(date, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated).hour().minute())
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                Text("(\(h2h.homeWins))")
                    .font(.system(.title3, design: .rounded).weight(.black))
                    .foregroundStyle(.green)
                    .frame(width: 36, alignment: .trailing)

                Text(match.homeTeam.abbreviation)
                    .font(.system(.body, design: .rounded).weight(.bold))
                    .frame(width: 38, alignment: .leading)

                Text(match.homeTeam.name)
                    .font(.subheadline)
                    .lineLimit(1)

                Spacer()

                if let score = match.homeScore {
                    Text("\(score)")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                }
            }

            HStack {
                Spacer()
                Text("vs")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
                Spacer()
            }

            HStack {
                Text("(\(h2h.awayWins))")
                    .font(.system(.title3, design: .rounded).weight(.black))
                    .foregroundStyle(.green)
                    .frame(width: 36, alignment: .trailing)

                Text(match.awayTeam.abbreviation)
                    .font(.system(.body, design: .rounded).weight(.bold))
                    .frame(width: 38, alignment: .leading)

                Text(match.awayTeam.name)
                    .font(.subheadline)
                    .lineLimit(1)

                Spacer()

                if let score = match.awayScore {
                    Text("\(score)")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                }
            }

            Divider()

            HStack {
                Image(systemName: "arrow.left.and.right")
                    .font(.caption2)
                    .foregroundStyle(.green)
                Text(viewModel.headToHeadSummary(for: match))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()

                if isCompleted {
                    let margin = abs((match.homeScore ?? 0) - (match.awayScore ?? 0))
                    let winner = (match.homeScore ?? 0) > (match.awayScore ?? 0) ? match.homeTeam : match.awayTeam
                    Text("\(winner.abbreviation) by \(margin)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    StatsPage(viewModel: StatsViewModel(matches: SampleData.matches))
}
