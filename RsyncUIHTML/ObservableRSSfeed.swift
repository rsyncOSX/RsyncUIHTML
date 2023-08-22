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

enum feeditmes: String, Identifiable, CaseIterable, CustomStringConvertible {
    case RsyncUI, RsyncOSX, Toppturer
    var id: String { rawValue }
    var description: String { rawValue.localizedCapitalized }
}

@MainActor
final class ObservableRSSfeed: ObservableObject {
    @Published var feed: RSSFeed?
    @Published var descriptions = [ItemDescription]()
    @Published var selectedgui: feeditmes = .RsyncUI

    var descriptiontext: String = ""
    var feedURL: URL?
    let rsyncuistring = "https://rsyncui.netlify.app/index.xml"
    let rsyncosxstring = "https://rsyncosx.netlify.app/index.xml"
    let toppturstring = "https://toppturer.netlify.app/index.xml"

    // Combine
    var subscriptions = Set<AnyCancellable>()

    init() {
        $selectedgui
            .sink { data in
                self.seturl(data)
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

    func seturl(_ url: feeditmes) {
        switch url {
        case .RsyncUI:
            feedURL = URL(string: rsyncuistring)
        case .RsyncOSX:
            feedURL = URL(string: rsyncosxstring)
        case .Toppturer:
            feedURL = URL(string: toppturstring)
        }
        fetchrssdata()
    }
}
