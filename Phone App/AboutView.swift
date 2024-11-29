//
//  AboutView.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-17.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.dismiss)
    var dismiss
    
    @State var items = AboutItem.all
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(items, id: \.self) { item in
                        // Question
                        if !item.text.isEmpty {
                            ExpandableSection {
                                ForEach(item.text, id: \.self) { text in
                                    Text.md(text)
                                }
                            } header: {
                                Text(item.title)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .textCase(.none)
                                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                    .padding(.trailing, 4)
                                    .minimumScaleFactor(0.9)
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                        } else {
                            // Section Title
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                }
                .padding(.top, -10)
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Text(verbatim: "🧪 1.0.0") // TODO: read version from config
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

struct AboutItem: Hashable {
    let title: String
    let text: [String]
    
    static let all: [AboutItem] = [
        AboutItem(title: String(localized: "Frequently Asked Questions"), text: []),
        AboutItem(title: "What is this app?", text: [
             """
             **Magic Tap** allows you to perform actions on your iPhone using the Double Tap gesture on your watch.
             """,
        ]),
        AboutItem(title: "Are all watches supported?", text: [
            """
            Yes! 🎉
            
            If your watch is a **Series 9 / Ultra or newer**, the 'Double Tap' gesture should already be enabled.
            
            **[👉 Tap here for more info](https://www.apple.com/uk/newsroom/2023/10/apple-watch-double-tap-gesture-now-available-with-watchos-10-1/)** on the Double Tap gesture for Series 9 / Ultra and newer models.
            
            If your watch is **older than the Series 9**, you'll need to enable 'Quick Actions' in your watch's accessibility settings. This can be found in the **Settings** app on your watch:
            
            **Settings > Accessibility > Quick Actions**
                        
            **[👉 Tap here for more info](https://support.apple.com/en-gb/guide/watch/apdec70bfd2d/watchos)** on enabling Quick Actions.
            """,
        ]),
        AboutItem(title: String(localized: "How do I install the watchOS app?"), text: [String(localized:
            """
            There are two ways to install Magic Tap app on Apple Watch:
            
            **1)** Open the **Watch** app on iOS, scroll down to Magic Tap in the list of apps, tap install
            
            **OR**
            
            **2)** Open the **App Store on the Apple Watch**, search for WatchCloud, tap install
            """),
        ]),
        AboutItem(title: "Can't I do this without the app?", text: [
            """
            Not exactly! 
            
            Magic Tap allows you to control many iOS apps and settings on your phone **without having to install the watchOS counterpart app**.  
            """,
        ]),
        AboutItem(title: "Where can I get help?", text: [
             """
             You can send an email to **[watchcloud.app@gmail.com](mailto:watchcloud.app@gmail.com)** 💌
             
             You can also visit the **[issues page](https://github.com/superturboryan/Magic-Tap/issues)** to see questions from the community, suggest a feature, or report a bug 👋🐞
             """,
        ]),
    ]
}

// AboutItem(title: "", text: [
//     """
//     """,
// ]),

struct ExpandableSection<Content: View, Header: View>: View {
    
    @State var isExpanded = false
    
    let content: () -> Content
    let header: () -> Header
    
    var body: some View {
        Section(
            isExpanded: $isExpanded,
            content: content,
            header: header
        )
    }
}

extension Text {
    
    static func md(_ markdownText: String) -> Text {
        var attributedString = try? AttributedString(
            markdown: markdownText,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        )
        attributedString?.foregroundColor = Color.primary
        return Text(attributedString ?? "⚠️ Failed to parse markdown")
    }
}
