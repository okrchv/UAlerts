//
//  AlarmCounterView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 27.12.2022.
//

import SwiftUI

struct AlarmCounterView: View {
    var startDate: Date?
    
    var body: some View {
        VStack(spacing: 0) {
            Text(startDate!, style: .timer)
                .font(
                    .system(size: 64)
                        .monospacedDigit()
                )
                .allowsTightening(true)
                .minimumScaleFactor(0.5)
            HStack(spacing: 5) {
                Image(systemName: "clock")
                    .font(.system(.body))
                Text(LocalizedStringKey("Started at \(Text(startDate!, style: .time))"))
                    .font(.system(.body))
            }
        }
    }
}

struct AlarmCounterView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmCounterView()
    }
}
