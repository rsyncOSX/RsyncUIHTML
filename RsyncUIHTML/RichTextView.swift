//
//  RichTextView.swift
//  RsyncUIHTML
//
//  Created by Thomas Evensen on 19/08/2023.
//

import RichText
import SwiftUI

struct RichTextView: View {
    var html = ""

    var body: some View {
        VStack {
            ScrollView {
                RichText(html: html)
                    .lineHeight(170)
                    .colorScheme(.auto)
                    .imageRadius(12)
                    .fontType(.system)
                    .foregroundColor(light: .lightGray, dark: .lightGray)
                    .linkColor(light: .linkColor, dark: .linkColor)
                    .colorPreference(forceColor: .onlyLinks)
                    .linkOpenType(.Safari)
                    .customCSS("")
                    .placeholder {
                        Text("Selecting the RSS-feed")
                    }
                    .transition(.easeOut)
            }
        }
        .padding()
    }
}

/*
 do {
    let html = "<html><head><title>First parse</title></head>"
        + "<body><p>Parsed HTML into a doc.</p></body></html>"
    let doc: Document = try SwiftSoup.parse(html)
    return try doc.text()
 } catch Exception.Error(let type, let message) {
     print(message)
 } catch {
     print("error")
 }
 */
