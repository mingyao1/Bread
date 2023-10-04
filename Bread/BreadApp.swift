//
//  BreadApp.swift
//  Bread
//
//  Created by Mingyao Li on 9/27/23.
//

import SwiftUI

@main
struct BreadApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                BibleView()
                    .tabItem { Label("Bible", systemImage: "book") }
                SearchView()
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
            }
        }
    }
}
