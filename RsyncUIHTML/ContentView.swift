//
//  ContentView.swift
//  RsyncUIHTML
//
//  Created by Thomas Evensen on 18/08/2023.
//

import FeedKit
import SwiftUI

struct ContentView: View {
    @State var rssfeed = ObservableRSSfeed()
    @State var selecteduuids = Set<ItemDescription.ID>()
    @State private var selectedgui: feeditmes = .RsyncUI

    var body: some View {
        NavigationSplitView {
            Table(rssfeed.descriptions, selection: $selecteduuids) {
                TableColumn("Topics", value: \.title)
            }
            .frame(minWidth: 300)
            .onChange(of: selecteduuids) {
                let selected = rssfeed.descriptions.filter { description in
                    selecteduuids.contains(description.id)
                }
                if selected.count == 1 {
                    rssfeed.descriptiontext = selected[0].descriptions
                } else {
                    rssfeed.descriptiontext = ""
                }
            }

        } detail: {
            RichTextView(html: rssfeed.descriptiontext)
        }
        .frame(minWidth: 1000, minHeight: 600)
        .padding()
        .toolbar(content: {
            ToolbarItem {
                guipicker
                    .tooltip("Select RSSfeed")
            }

        })
    }

    var guipicker: some View {
        Picker("Application", selection: $selectedgui) {
            ForEach(feeditmes.allCases) { Text($0.description)
                .tag($0)
            }
        }
        .frame(width: 200)
        .accentColor(.blue)
        .onAppear {
            Task {
                selectedgui = .RsyncUI
                await rssfeed.seturl(selectedgui)
            }
        }
        .padding(2)
        .onChange(of: selectedgui) {
            rssfeed.descriptiontext = ""
            Task {
                await rssfeed.seturl(selectedgui)
            }
        }
    }
}

extension View {
    func tooltip(_ tip: String) -> some View {
        ZStack {
            background(GeometryReader { childGeometry in
                TooltipView(tip, geometry: childGeometry) {
                    self
                }
            })
            self
        }
    }
}

struct TooltipView<Content>: View where Content: View {
    let content: () -> Content
    let tip: String
    let geometry: GeometryProxy

    init(_ tip: String, geometry: GeometryProxy, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.tip = tip
        self.geometry = geometry
    }

    var body: some View {
        Tooltip(tip, content: content)
            .frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct Tooltip<Content: View>: NSViewRepresentable {
    typealias NSViewType = NSHostingView<Content>

    init(_ text: String?, @ViewBuilder content: () -> Content) {
        self.text = text
        self.content = content()
    }

    let text: String?
    let content: Content

    func makeNSView(context _: Context) -> NSHostingView<Content> {
        NSViewType(rootView: content)
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context _: Context) {
        nsView.rootView = content
        nsView.toolTip = text
    }
}
