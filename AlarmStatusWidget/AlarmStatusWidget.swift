//
//  AlarmStatusWidget.swift
//  AlarmStatusWidget
//
//  Created by Oleh Kiurchev on 21.07.2022.
//

import WidgetKit
import SwiftUI
import UkraineAlertAPI

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> AlarmEntry {
        AlarmEntry(date: Date(), status: AlertRegionModel())
    }

    func getSnapshot(for configuration: AlarmStatusWidgetConfigIntent, in context: Context, completion: @escaping (AlarmEntry) -> ()) {
        var status = AlertRegionModel()

        if (context.isPreview) {
            status.regionName = "м. Київ"
            status.lastUpdate = Calendar.current.date(byAdding: .year, value: -10, to: Date.now)
        }
        
        let entry = AlarmEntry(date: Date(), status: status)

        completion(entry)
    }
    
    func getTimeline(for configuration: AlarmStatusWidgetConfigIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let regionStatusResponse = try await Client.shared.send(Paths.alerts.regionID(configuration.region!.identifier!).get)
            let regionStatus = regionStatusResponse.value.last!

            let currentDate = Date.now
            let nextDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!

            let timeline = Timeline(
                entries: [AlarmEntry(date: currentDate, status: regionStatus)],
                policy: .after(nextDate)
            )
            
            completion(timeline)
        }
    }
}

struct AlarmEntry: TimelineEntry {
    let date: Date
    let status: AlertRegionModel
}

struct AlarmStatusWidgetEntryView : View {
    var entry: AlarmEntry
    
    var body: some View {
        AlarmStatusWidgetView(
            status: entry.status
        )
    }
}

@main
struct AlarmStatusWidget: Widget {
    let kind: String = "AlarmStatusWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: AlarmStatusWidgetConfigIntent.self,
            provider: Provider()
        ) { entry in
            AlarmStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Air alarm status")
        .description("Check air alarm status changes in your location.")
        .supportedFamilies([.systemSmall])
    }
}

//struct AlarmStatusWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        AlarmStatusWidgetEntryView(entry: SimpleEntry(date: Date(), status: nil))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
