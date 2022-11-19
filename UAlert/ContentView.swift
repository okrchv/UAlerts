//
//  ContentView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 21.07.2022.
//

import SwiftUI
import UkraineAlertAPI
import WidgetKit

struct ContentView: View {
    var body: some View {
//        AlarmStatusWidgetView(status: .calm, startDate: Date(), lastDate: Date())
//            .frame(width: 160, height: 160)
//            .border(.blue, width: 1)
        AlertsChartView()
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
