//
//  ObservableRSSfeed.swift
//  RsyncUIHTML
//
//  Created by Thomas Evensen on 18/08/2023.
//

import FeedKit
import Foundation
import Observation

struct ItemDescription: Identifiable {
    let id = UUID()
    var descriptions: String = ""
    var title: String = ""
}

enum feeditmes: String, Identifiable, CaseIterable, CustomStringConvertible {
    case RsyncUI, RsyncOSX
    var id: String { rawValue }
    var description: String { rawValue.localizedCapitalized }
}

@Observable
final class ObservableRSSfeed {
    var descriptiontext: String = ""

    @ObservationIgnored
    var feed: RSSFeed?
    var descriptions = [ItemDescription]()
    var feedURL: URL?
    let rsyncuistring = "https://rsyncui.netlify.app/index.xml"
    let rsyncosxstring = "https://rsyncosx.netlify.app/index.xml"

    private func fetchrssdata() async {
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

    func seturl(_ url: feeditmes) async {
        switch url {
        case .RsyncUI:
            feedURL = URL(string: rsyncuistring)
        case .RsyncOSX:
            feedURL = URL(string: rsyncosxstring)
        }
        await fetchrssdata()
    }
}
