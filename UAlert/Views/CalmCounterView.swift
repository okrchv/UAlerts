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
            if (date < invasionDate ) {
                Text(LocalizedStringKey("out of data\nabout last alarm"))
                    .font(.system(.headline))
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
            } else if (date < Calendar.current.startOfDay(for: Date.now)) {
                VStack(spacing: 0) {
                    Text(date..<Date.now, format: .components(style: .wide, fields: [.year, .month, .week, .day]))
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
