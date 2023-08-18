//
//  ObservableRSSfeed.swift
//  RsyncUIHTML
//
//  Created by Thomas Evensen on 18/08/2023.
//

import FeedKit
import Foundation

@MainActor
final class ObservableRSSfeed: ObservableObject {
    @Published var feed: RSSFeed?
    let feedURL = URL(string: "https://rsyncui.netlify.app/index.xml")!
    // let feedURL = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!

    private func fetchrssdata() {
        let parser = FeedParser(URL: feedURL)
        // Parse asynchronously, not to block the UI.
        parser.parseAsync { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(localfeed):
                DispatchQueue.main.async {
                    self.feed = localfeed.rssFeed
                }
                // Grab the parsed feed directly as an optional rss, atom or json feed object

                // Or alternatively...
                //
                // switch feed {
                // case .rss(let feed): break
                // case .atom(let feed): break
                // case .json(let feed): break
                // }

            // Then back to the Main thread to update the UI.
            /*
             DispatchQueue.main.async {
                 self.feedItemsTableView.reloadData()
             }
             */
            case let .failure(error):
                print(error)
            }
        }
    }

    init() {
        fetchrssdata()
    }
}
