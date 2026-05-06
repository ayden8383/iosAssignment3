//
//  MainTabView.swift
//
//  Root navigation connecting the four main pages to the shared AppViewModel.

import SwiftUI

struct MainTabView: View {
    @StateObject private var appViewModel = AppViewModel()

    var body: some View {
        TabView(selection: $appViewModel.selectedTab) {
            HomePage(viewModel: appViewModel)
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.iconName)
                }
                .tag(AppTab.home)

            TipsPage(viewModel: appViewModel)
                .tabItem {
                    Label(AppTab.tips.title, systemImage: AppTab.tips.iconName)
                }
                .tag(AppTab.tips)

            StatsPage(viewModel: appViewModel.statsViewModel)
                .tabItem {
                    Label(AppTab.stats.title, systemImage: AppTab.stats.iconName)
                }
                .tag(AppTab.stats)

            ScoreboardPage(viewModel: appViewModel.scoreboardViewModel)
                .tabItem {
                    Label(AppTab.scoreboard.title, systemImage: AppTab.scoreboard.iconName)
                }
                .tag(AppTab.scoreboard)
        }
        .task {
            await appViewModel.loadNRLData()
        }
    }
}

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    MainTabView()
}

#Preview("Content View") {
    ContentView()
}
