//
//  ObservableRSSfeed.swift
//  RsyncUIHTML
//
//  Created by Thomas Evensen on 18/08/2023.
//

import FeedKit
import Foundation

struct ItemDescription: Identifiable {
    let id = UUID()
    var descriptions: String = ""
    var title: String = ""
}

@MainActor
final class ObservableRSSfeed: ObservableObject {
    @Published var feed: RSSFeed?
    @Published var descriptions = [ItemDescription]()

    var descriptiontext: String = ""
    let feedURL = URL(string: "https://rsyncui.netlify.app/index.xml")!

    private func fetchrssdata() {
        let parser = FeedParser(URL: feedURL)
        parser.parseAsync { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(localfeed):
                DispatchQueue.main.async {
                    self.feed = localfeed.rssFeed
                    self.descriptions.removeAll()
                    for i in 0 ..< (self.feed?.items?.count ?? 0) {
                        if let description = self.feed?.items?[i].description,
                           let title = self.feed?.items?[i].title
                        {
                            self.descriptions.append(ItemDescription(descriptions: description, title: title))
                        }
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    init() {
        fetchrssdata()
    }
}
