//
//  AlarmStatusWidget.swift
//  AlarmStatusWidget
//
//  Created by Oleh Kiurchev on 21.07.2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct AlarmStatusWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        AlarmStatusWidgetView(
            status: .calm,
            startDate: Date(),
            lastDate: Calendar.current.date(byAdding: .minute, value: -300, to: Date.now)!
        )
    }
}

@main
struct AlarmStatusWidget: Widget {
    let kind: String = "AlarmStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AlarmStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Air alarm status")
        .description("Check air alarm status changes in your location.")
    }
}

struct AlarmStatusWidget_Previews: PreviewProvider {
    static var previews: some View {
        AlarmStatusWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
