//
//  HomePage.swift
//
//  Home screen for the NRL Tipping Comp.
//  Shows round header, tip progress, recent results, and upcoming fixtures.

import SwiftUI

struct HomePage: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    roundHeader
                    tipProgressCard
                    if !viewModel.completedMatches.isEmpty {
                        resultsSection
                    }
                    if !viewModel.upcomingMatches.isEmpty {
                        upcomingSection
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("NRL Tipping")
        }
    }

    // MARK: - Round Header

    private var roundHeader: some View {
        VStack(spacing: 6) {
            Text("ROUND \(viewModel.currentRound)")
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            Text("2026 NRL Season")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
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

    // MARK: - Tip Progress

    private var tipProgressCard: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Color.green.opacity(0.18), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: viewModel.tipProgress)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.6), value: viewModel.tipProgress)
                Text("\(viewModel.tipsPlaced)/\(viewModel.matches.count)")
                    .font(.system(.title3, design: .rounded).weight(.bold))
            }
            .frame(width: 68, height: 68)

            VStack(alignment: .leading, spacing: 4) {
                Text("Your Tips")
                    .font(.headline)
                Text("\(viewModel.tipsPlaced) of \(viewModel.matches.count) placed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 12) {
                    Label("\(viewModel.tipsCorrect) correct", systemImage: "checkmark.circle.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.green)
                    let wrong = viewModel.tipsPlaced - viewModel.tipsCorrect
                        - viewModel.tips.filter({ $0.selectedTeam != nil && $0.match.homeScore == nil }).count
                    if wrong > 0 {
                        Label("\(wrong) wrong", systemImage: "xmark.circle.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.red)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    // MARK: - Recent Results

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Recent Results", icon: "clock.fill")

            ForEach(viewModel.completedMatches) { match in
                completedMatchCard(match)
            }
        }
    }

    private func completedMatchCard(_ match: Match) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("FULL TIME")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer()
                if let date = match.scheduledDate {
                    Text(date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 10)

            teamScoreRow(
                abbreviation: match.homeTeam.abbreviation,
                name: match.homeTeam.name,
                score: match.homeScore ?? 0,
                isWinner: (match.homeScore ?? 0) > (match.awayScore ?? 0)
            )

            Divider()
                .padding(.vertical, 6)

            teamScoreRow(
                abbreviation: match.awayTeam.abbreviation,
                name: match.awayTeam.name,
                score: match.awayScore ?? 0,
                isWinner: (match.awayScore ?? 0) > (match.homeScore ?? 0)
            )

            if let tip = viewModel.tip(for: match), let selected = tip.selectedTeam {
                Divider()
                    .padding(.top, 8)
                tipResultRow(selected: selected, match: match)
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func teamScoreRow(abbreviation: String, name: String, score: Int, isWinner: Bool) -> some View {
        HStack {
            Text(abbreviation)
                .font(.system(.body, design: .rounded).weight(.bold))
                .frame(width: 40, alignment: .leading)
            Text(name)
                .font(.subheadline)
                .foregroundStyle(isWinner ? .primary : .secondary)
                .lineLimit(1)
            Spacer()
            Text("\(score)")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(isWinner ? .primary : .secondary)
        }
    }

    private func tipResultRow(selected: Team, match: Match) -> some View {
        let homeScore = match.homeScore ?? 0
        let awayScore = match.awayScore ?? 0
        let winner = homeScore > awayScore ? match.homeTeam : match.awayTeam
        let correct = selected.id == winner.id

        return HStack {
            Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(correct ? .green : .red)
            Text("Tipped \(selected.abbreviation)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(correct ? .green : .red)
            Spacer()
        }
    }

    // MARK: - Upcoming Matches

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Upcoming Matches", icon: "calendar")

            ForEach(viewModel.upcomingMatches) { match in
                upcomingMatchCard(match)
            }
        }
    }

    private func upcomingMatchCard(_ match: Match) -> some View {
        VStack(spacing: 10) {
            if let date = match.scheduledDate {
                HStack {
                    Text(date, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(date, format: .dateTime.hour().minute())
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                Text(match.homeTeam.abbreviation)
                    .font(.system(.body, design: .rounded).weight(.bold))
                Text(match.homeTeam.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer()
            }

            HStack {
                Text(match.awayTeam.abbreviation)
                    .font(.system(.body, design: .rounded).weight(.bold))
                Text(match.awayTeam.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer()
            }

            Divider()

            HStack {
                if let tip = viewModel.tip(for: match), let selected = tip.selectedTeam {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Tipped \(selected.abbreviation)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundStyle(.orange)
                    Text("No tip placed")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
                Spacer()
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(.green)
            Text(title)
                .font(.title3.weight(.bold))
        }
        .padding(.top, 4)
    }
}

#Preview {
    HomePage(viewModel: HomeViewModel(matches: SampleData.matches, tips: SampleData.tips))
}
