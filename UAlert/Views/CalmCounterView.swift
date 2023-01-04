//
//  CalmCounterView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 26.12.2022.
//

import SwiftUI

struct CalmCounterView: View {
    let invasionDate = Date(timeIntervalSince1970: 1645678800)
    
    var lastUpdate: Date?

    var body: some View {
        if let date = lastUpdate {
            // We consider all alert end dates before 24.02.2022 as anomalies
            if (date < invasionDate) {
                Text(LocalizedStringKey("out of data\nabout last alarm"))
                    .font(.system(.headline))
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
            // We should display all dates for alerts which ended yesterday and earlier
            // as day count starting with "1 day" if alert was ended yesterday
            } else if (date < Calendar.current.startOfDay(for: Date.now)) {
                
                let tomorrowStart = Calendar.current.startOfDay(
                    for: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!
                )
                
                VStack(spacing: 0) {
                    Text(date..<tomorrowStart, format: .components(style: .wide, fields: [.year, .month, .week, .day]))
                        .font(.system(size: 64))
                        .lineLimit(1)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.5)
                    Text(LocalizedStringKey("without air alarms"))
                        .font(.system(.body))
                        .fixedSize()
                        .allowsTightening(true)
                        .minimumScaleFactor(0.5)
                }
            // If alert was ended today we should display time when this event was happened
            } else {
                VStack(spacing: 0) {
                    Text(date, format: .dateTime.hour().minute())
                        .font(.system(size: 64))
                    Text(LocalizedStringKey("end of the last alarm"))
                        .font(.system(.body))
                        .lineLimit(1)
                        .fixedSize()
                        .allowsTightening(true)
                        .minimumScaleFactor(0.5)
                }
            }
        }
    }
}

struct CalmCounterView_Previews: PreviewProvider {
    static var previews: some View {
        CalmCounterView()
    }
}
