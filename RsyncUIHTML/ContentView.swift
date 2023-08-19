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
    @State var selecteduuids = Set<ItemDescription.ID>()
    @State private var presentsheet: Bool = false
    @State private var selectedgui: String = ""

    var body: some View {
        VStack {
            Table(rssfeed.descriptions, selection: $selecteduuids.onChange {
                let selected = rssfeed.descriptions.filter { description in
                    selecteduuids.contains(description.id)
                }
                if selected.count == 1 {
                    rssfeed.descriptiontext = selected[0].descriptions
                } else {
                    rssfeed.descriptiontext = ""
                }
            }) {
                TableColumn("Title") { data in
                    Text(String(data.title))
                }
            }
            .padding()

            HStack {
                guipicker

                Spacer()

                Button("HTML") { presentsheet = true }
                    .buttonStyle(ColorfulButtonStyle())
                    .sheet(isPresented: $presentsheet) { RichTextView(html: rssfeed.descriptiontext) }
            }
        }
        .padding()
    }

    var guipicker: some View {
        Picker("", selection: $selectedgui.onChange {
            rssfeed.selectedgui = selectedgui
        }) {
            ForEach(rssfeed.guis, id: \.self) { gui in
                Text(gui)
                    .tag(gui)
            }
        }
        .frame(width: 180)
        .accentColor(.blue)
    }
}

extension Binding {
    /// Updates the binding then calls a closure without the new value.
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler()
            }
        )
    }
}

extension Color {
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)

    static let lightStart = Color(red: 60 / 255, green: 160 / 255, blue: 240 / 255)
    static let lightEnd = Color(red: 30 / 255, green: 80 / 255, blue: 120 / 255)

    static let darkredStart = Color(red: 200 / 255, green: 0 / 255, blue: 0 / 255)
    static let darkredEnd = Color(red: 150 / 255, green: 0 / 255, blue: 0 / 255)

    static let lightredStart = Color(red: 100 / 255, green: 0 / 255, blue: 0 / 255)
    static let lightredEnd = Color(red: 50 / 255, green: 0 / 255, blue: 0 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct ColorfulRedBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightredEnd, Color.lightredStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightredStart, Color.lightredEnd), lineWidth: 2))
                    .shadow(color: Color.darkredStart, radius: 2, x: 1, y: 1)
                    .shadow(color: Color.darkredEnd, radius: 2, x: -1, y: -1)
            } else {
                shape
                    .fill(LinearGradient(Color.darkredStart, Color.darkredEnd))
                    .overlay(shape.stroke(LinearGradient(Color.lightredStart, Color.lightredEnd), lineWidth: 2))
                    .shadow(color: Color.darkredStart, radius: 2, x: -1, y: -1)
                    .shadow(color: Color.darkredEnd, radius: 2, x: 1, y: 1)
            }
        }
    }
}

struct ColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 2))
                    .shadow(color: Color.darkStart, radius: 2, x: 1, y: 1)
                    .shadow(color: Color.darkEnd, radius: 2, x: -1, y: -1)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 2))
                    .shadow(color: Color.darkStart, radius: 2, x: -1, y: -1)
                    .shadow(color: Color.darkEnd, radius: 2, x: 1, y: 1)
            }
        }
    }
}

struct ColorfulButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(8)
            .contentShape(Capsule())
            .background(
                ColorfulBackground(isHighlighted: configuration.isPressed, shape: Capsule())
            )
    }
}

struct ColorfulRedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(8)
            .contentShape(Capsule())
            .background(
                ColorfulRedBackground(isHighlighted: configuration.isPressed, shape: Capsule())
            )
    }
}
