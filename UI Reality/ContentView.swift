//
//  ContentView.swift
//  UI Reality
//
//  Created by Pardn on 2024/11/21.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
		Text("項目都在 /page 中，不在這一頁")

    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
