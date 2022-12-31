//
//  AlarmStatusWidgetView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 21.07.2022.
//

import SwiftUI
import UkraineAlertAPI

struct AlarmStatusWidgetView: View {
    var status: AlertRegionModel

    var body: some View {
        if ((status.activeAlerts ?? []).isEmpty) {
            CalmWidgetView(
                lastUpdate: status.lastUpdate,
                regionName: status.regionName
            )
        } else {
            AlarmWidgetView(
                startDate: status.lastUpdate,
                regionName: status.regionName
            )
        }
    }
}

//struct AlarmStatusWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            AlarmStatusWidgetView(status: .alarm, startDate: Date(), lastDate: Date())
//                .environment(\.locale, .init(identifier: "uk"))
//                .previewDevice("iPhone 8")
//                .previewLayout(.fixed(width: 160, height: 160))
//        }
//    }
//}
