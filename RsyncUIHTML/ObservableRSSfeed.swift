//
//  ObservableRSSfeed.swift
//  RsyncUIHTML
//
//  Created by Thomas Evensen on 18/08/2023.
//

import Combine
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
    @Published var selectedgui: String?

    var descriptiontext: String = ""
    var feedURL: URL?
    let guis = ["RsyncUI", "RsyncOSX"]
    let rsyncuistring = "https://rsyncui.netlify.app/index.xml"
    let rsyncosxstring = "https://rsyncosx.netlify.app/index.xml"

    // Combine
    var subscriptions = Set<AnyCancellable>()

    init() {
        $selectedgui
            .sink { data in
                self.seturl(data ?? "")
            }.store(in: &subscriptions)
    }

    private func fetchrssdata() {
        if let url = feedURL {
            let parser = FeedParser(URL: url)
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
    }

    func seturl(_ url: String) {
        switch url {
        case "RsyncUI":
            feedURL = URL(string: rsyncuistring)
        case "RsyncOSX":
            feedURL = URL(string: rsyncosxstring)
        default:
            feedURL = nil
        }
        fetchrssdata()
    }
}
