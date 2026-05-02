//
//  TipsPage.swift
//
//  Tips screen where users pick their winners for each match in the round.

import SwiftUI

struct TipsPage: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    progressHeader
                    ForEach(viewModel.matches) { match in
                        matchTipCard(match)
                    }
                    if !viewModel.allTipsLocked {
                        lockAllButton
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Round \(viewModel.currentRound) Tips")
        }
    }

    // MARK: - Progress Header

    private var progressHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(viewModel.tipsPlaced) of \(viewModel.matches.count) tips placed")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                Spacer()
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.green.opacity(0.18))
                        .frame(height: 8)
                    Capsule()
                        .fill(Color.green)
                        .frame(
                            width: viewModel.matches.isEmpty
                                ? 0
                                : geo.size.width * CGFloat(viewModel.tipsPlaced) / CGFloat(viewModel.matches.count),
                            height: 8
                        )
                        .animation(.easeInOut(duration: 0.4), value: viewModel.tipsPlaced)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    // MARK: - Match Tip Card

    private func matchTipCard(_ match: Match) -> some View {
        let tip = viewModel.tip(for: match)
        let isCompleted = match.homeScore != nil && match.awayScore != nil
        let isLocked = tip?.isLocked ?? false

        return VStack(spacing: 14) {
            matchDateHeader(match: match, isCompleted: isCompleted)

            HStack(spacing: 12) {
                teamButton(
                    team: match.homeTeam,
                    score: match.homeScore,
                    isSelected: tip?.selectedTeam?.id == match.homeTeam.id,
                    isDisabled: (isLocked || isCompleted),
                    isWinner: isCompleted && (match.homeScore ?? 0) > (match.awayScore ?? 0)
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectTeam(match.homeTeam, for: match)
                    }
                }

                Text("VS")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)

                teamButton(
                    team: match.awayTeam,
                    score: match.awayScore,
                    isSelected: tip?.selectedTeam?.id == match.awayTeam.id,
                    isDisabled: (isLocked || isCompleted),
                    isWinner: isCompleted && (match.awayScore ?? 0) > (match.homeScore ?? 0)
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectTeam(match.awayTeam, for: match)
                    }
                }
            }

            if isCompleted {
                completedResultBanner(tip: tip, match: match)
            } else if let tip, tip.selectedTeam != nil {
                tipActionButtons(match: match, isLocked: isLocked)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func matchDateHeader(match: Match, isCompleted: Bool) -> some View {
        HStack {
            if isCompleted {
                Text("FULL TIME")
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let date = match.scheduledDate {
                Text(date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day().hour().minute())
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Team Button

    private func teamButton(
        team: Team,
        score: Int?,
        isSelected: Bool,
        isDisabled: Bool,
        isWinner: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(team.abbreviation)
                    .font(.system(.title2, design: .rounded).weight(.black))
                Text(team.name)
                    .font(.caption2)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                if let score {
                    Text("\(score)")
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isSelected ? Color.green.opacity(0.12) : Color(.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(
                        isSelected ? Color.green : Color.clear,
                        lineWidth: 2.5
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled && !isSelected ? 0.5 : 1)
    }

    // MARK: - Tip Action Buttons

    private func tipActionButtons(match: Match, isLocked: Bool) -> some View {
        HStack(spacing: 10) {
            if isLocked {
                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                    Text("Tip Locked")
                        .font(.subheadline.weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.green.opacity(0.12))
                .foregroundStyle(.green)
                .clipShape(Capsule())

                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.unlockTip(for: match)
                    }
                } label: {
                    Text("Change")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color(.tertiarySystemFill))
                        .foregroundStyle(.primary)
                        .clipShape(Capsule())
                }
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.lockTip(for: match)
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "lock.open")
                        Text("Lock Tip")
                            .font(.subheadline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
            }
        }
    }

    // MARK: - Completed Result Banner

    private func completedResultBanner(tip: Tip?, match: Match) -> some View {
        let homeScore = match.homeScore ?? 0
        let awayScore = match.awayScore ?? 0
        let winner = homeScore > awayScore ? match.homeTeam : match.awayTeam

        return Group {
            if let selected = tip?.selectedTeam {
                let correct = selected.id == winner.id
                HStack(spacing: 6) {
                    Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    Text(correct ? "Correct — Tipped \(selected.abbreviation)" : "Wrong — Tipped \(selected.abbreviation)")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(correct ? .green : .red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    (correct ? Color.green : Color.red).opacity(0.08),
                    in: Capsule()
                )
            }
        }
    }

    // MARK: - Lock All Button

    private var lockAllButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.lockAllTips()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "lock.fill")
                Text("Lock All Tips")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.06, green: 0.30, blue: 0.18),
                             Color(red: 0.10, green: 0.52, blue: 0.30)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
        .disabled(viewModel.tipsPlaced == 0)
        .opacity(viewModel.tipsPlaced == 0 ? 0.5 : 1)
        .padding(.top, 4)
    }
}

#Preview {
    TipsPage(viewModel: AppViewModel())
}
