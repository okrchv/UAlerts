//
//  AlarmStatusMediumWidgetView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 02.09.2022.
//

import SwiftUI
import UkraineAlertAPI

struct AlarmStatusMediumWidgetView: View {
    var status: AlertRegionModel
    
    var body: some View {
        if ((status.activeAlerts ?? []).isEmpty) {
            HStack {
                AlarmStatusWidgetView(status: status)
                Spacer()
                VStack {
                    Text(LocalizedStringKey("alarms\nnow in Ukraine"))
                        .font(.system(.subheadline))
                        .fixedSize()
                        .lineLimit(2)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.5)
                        .padding()
                    Spacer()
                    HStack {
                        Text(LocalizedStringKey("Shelters map"))
                        Image(systemName: "map.fill")
                    }
                    .font(.system(.subheadline))
                    .padding()
                }
            }
            .foregroundColor(.secondary)
        } else {
            HStack {
                AlarmStatusWidgetView(status: status)
                Spacer()
                VStack(alignment: .leading) {
                    Text(LocalizedStringKey("alarms\nnow in Ukraine"))
                        .fixedSize()
                        .lineLimit(2)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.5)
                        .padding()
                    Spacer()
                    HStack {
                        Text(LocalizedStringKey("10 min to the nearest shelter"))
                        Image(systemName: "mappin.circle.fill")
                    }
                    .font(.system(.subheadline))
                    .padding()
                }
            }
            .font(.system(.subheadline))
            .background(.red)
            .foregroundColor(.white)
        }
    }
}

//struct AlarmStatusMediumWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlarmStatusMediumWidgetView()
//    }
//}
