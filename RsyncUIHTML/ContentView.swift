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
        Table(rssfeed.descriptions) {
            TableColumn("Title") { data in
                Text(String(data.title))
            }

            TableColumn("Description") { data in
                Text(String(data.descriptions))
            }
        }
        .padding()
    }
}
