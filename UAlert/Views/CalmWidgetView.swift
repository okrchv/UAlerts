//
//  CalmWidgetView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 25.07.2022.
//

import SwiftUI

struct CalmWidgetView: View {
    var lastDate: Date
    
    let dateFormatter: DateComponentsFormatter

    init(lastDate: Date) {
        self.lastDate = lastDate

        dateFormatter = DateComponentsFormatter()
        
        dateFormatter.unitsStyle = .full
        dateFormatter.allowedUnits = [.year, .month, .weekOfMonth, .day]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.collapsesLargestUnit = true
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Text(LocalizedStringKey("Everything  \nis calm"))
                    .font(.system(.caption, design: .rounded))
                    .kerning(1)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .lineLimit(2)
                    .fixedSize()
                    .foregroundColor(.green)
                Spacer()
                ZStack {
                    Image(systemName: "shield.righthalf.filled").foregroundColor(.yellow)
                    Image(systemName: "shield.lefthalf.filled").foregroundColor(.blue)
                }.font(.system(.title))
            }
            Spacer()
            HStack(spacing: 5) {
                Text("Київ")
                    .fontWeight(.semibold)
                    .font(.system(.caption2))
                Image(systemName: "location.fill")
                    .font(.system(.caption2))
            }
            Spacer()

            if (lastDate < Calendar.current.startOfDay(for: Date.now)) {
                Text(dateFormatter.string(from: lastDate, to: Date.now) ?? "")
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
                Spacer()
                Text(LocalizedStringKey("without air alarms"))
                    .font(.system(.subheadline))
                    .fontWeight(.semibold)
                    .fixedSize()
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
            } else {
                Text(lastDate, format: .dateTime.hour().minute())
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
                Text(LocalizedStringKey("end of the last alarm"))
                    .font(.system(.subheadline))
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
            }
        }
        .foregroundColor(.secondary)
        .padding()
    }
}

struct CalmWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalmWidgetView(lastDate: Date())
                .environment(\.locale, .init(identifier: "uk"))
                .preferredColorScheme(.light)
                .previewLayout(.fixed(width: 160, height: 160))
            CalmWidgetView(lastDate: Date())
                .environment(\.locale, .init(identifier: "uk"))
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 160, height: 160))
        }
    }
}
