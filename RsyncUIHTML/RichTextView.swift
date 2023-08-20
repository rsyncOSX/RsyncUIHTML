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
                /*
                 .placeholder {
                     Text("loading")
                 }
                 .transition(.easeOut)
                  */
            }
        }
        .padding()
    }
}
