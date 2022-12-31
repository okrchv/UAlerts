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
    @AppStorage("userRegionId") private var selectedRegion = ""
    
    var body: some View {
        if selectedRegion.isEmpty {
            NoRegionView()
        } else {
            HomeScreenView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
