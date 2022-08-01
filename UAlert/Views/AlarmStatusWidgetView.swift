//
//  AlarmStatusWidgetView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 21.07.2022.
//

import SwiftUI

enum AlarmStatus {
    case calm
    case alarm
}

struct AlarmStatusWidgetView: View {
    var status: AlarmStatus
    
    var startDate: Date
    var lastDate: Date
    
    var body: some View {
        switch (status) {
        case .calm:
            CalmWidgetView(lastDate: lastDate)
        case .alarm:
            AlarmWidgetView(startDate: startDate)
        }
    }
}

struct AlarmStatusWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlarmStatusWidgetView(status: .alarm, startDate: Date(), lastDate: Date())
                .environment(\.locale, .init(identifier: "uk"))
                .previewDevice("iPhone 8")
                .previewLayout(.fixed(width: 160, height: 160))
        }
    }
}
