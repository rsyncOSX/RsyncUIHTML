//
//  ContentView.swift
//  RsyncUIHTML
//
//  Created by Thomas Evensen on 18/08/2023.
//

import FeedKit
import SwiftUI

struct ContentView: View {
    @StateObject var rssfeed = ObservableRSSfeed()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}
