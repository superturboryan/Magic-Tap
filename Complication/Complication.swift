//
//  Complication.swift
//  Complication
//
//  Created by Ryan Forsyth on 2023-09-22.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date(), emoji: "😀"))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let timeline = Timeline(
            entries: [SimpleEntry(date: .now, emoji: "😀")],
            policy: .atEnd
        )
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    
    let date: Date
    let emoji: String
}

struct ComplicationEntryView : View {
    
    @Environment(\.widgetFamily)
    private var family
    
    var entry: Provider.Entry

    var body: some View {
        Text("👌")
    }
}

@main
struct Complication: Widget {
    
    let kind: String = "Complication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ComplicationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Open Magic Tap")
        .description("Opens the Magic Tap app")
        .supportedFamilies([.accessoryCircular, .accessoryCorner])
    }
}

#Preview(as: .accessoryCorner) {
    Complication()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}

#Preview(as: .accessoryCircular) {
    Complication()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}

