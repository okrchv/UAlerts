//
//  AlarmWidgetView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 25.07.2022.
//

import SwiftUI

struct AlarmWidgetView: View {
    var startDate: Date?
    var regionName: String?

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Text(LocalizedStringKey("Air\nalarm"))
                    .font(.system(.caption, design: .rounded))
                    .kerning(1)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .lineLimit(2)
                    .fixedSize()
                Spacer()
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(.title))
            }
            Spacer()
            HStack(spacing: 5) {
                if let name = regionName {
                    Text(name).fontWeight(.semibold)
                } else {
                    Text(LocalizedStringKey("N/A")).fontWeight(.semibold)
                }
                Image(systemName: "location.fill")
                    
            }.font(.system(.caption2))
            Spacer()
            Text(startDate!, style: .timer)
                .font(
                    .system(.largeTitle, design: .rounded)
                        .monospacedDigit()
                )
                .allowsTightening(true)
                .minimumScaleFactor(0.5)
            Spacer()
            HStack(spacing: 5) {
                Image(systemName: "clock")
                    .font(.system(.caption))
                Text(LocalizedStringKey("Started at \(Text(startDate!, style: .time))"))
                    .font(.system(.caption))
                    .fontWeight(.semibold)
                    .fixedSize()
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
            }
        }
        .padding()
        .background(.red)
        .foregroundColor(.white)
    }
}

//struct AlarmView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlarmWidgetView(startDate: Date())
//            .environment(\.locale, .init(identifier: "uk"))
//            .previewLayout(.fixed(width: 160, height: 160))
//    }
//}
