//
//  MainTabView.swift
//
//  Use this file for the root SwiftUI navigation.
//  This view connects the four main app pages to the shared AppViewModel.
//  Keep detailed page UI inside each individual page file.

import SwiftUI

struct MainTabView: View {
    @StateObject private var appViewModel = AppViewModel()

    var body: some View {
        TabView(selection: $appViewModel.selectedTab) {
            HomePage(viewModel: appViewModel.homeViewModel)
                .tabItem { Text(AppTab.home.title) }
                .tag(AppTab.home)

            TipsPage(viewModel: appViewModel.tipsViewModel)
                .tabItem { Text(AppTab.tips.title) }
                .tag(AppTab.tips)

            StatsPage(viewModel: appViewModel.statsViewModel)
                .tabItem { Text(AppTab.stats.title) }
                .tag(AppTab.stats)

            ScoreboardPage(viewModel: appViewModel.scoreboardViewModel)
                .tabItem { Text(AppTab.scoreboard.title) }
                .tag(AppTab.scoreboard)
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
