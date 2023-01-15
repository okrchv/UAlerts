//
//  HomeScreenView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 14.12.2022.
//

import SwiftUI
import UkraineAlertAPI

struct HomeScreenView: View {
    @AppStorage("userRegionIdState") private var selectedRegionState = ""
    @AppStorage("userRegionId") private var selectedRegion = ""
    @AppStorage("userRegionName") private var regionName = ""
    
    @EnvironmentObject private var appDelegate: AppDelegate

    @State var completion = false
    @State var status: [UkraineAlertAPI.Alert] = []
    @State var lastUpdate: Date?
    @State var showRegion = false

    var body: some View {
        ZStack {
            if completion == false {
                Color.white.opacity(0.0)
                    .edgesIgnoringSafeArea(.all)
            } else if (status.isEmpty) {
                Color.green.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.red.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
            }
        
            VStack {
                VStack {
                    Spacer()
                    Spacer()
                    VStack(spacing: 20) {
                        if completion == false {
                            ProgressView()
                        } else if (status.isEmpty) {
                            Text(LocalizedStringKey("There is no danger"))
                                .font(.system(.title3))
                                .kerning(0.5)
                            CalmCounterView(lastUpdate: lastUpdate)
                        } else {
                            Text(LocalizedStringKey("An emergency alert is active!"))
                                .font(.system(.title3))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 2)
                            AlarmCounterView(startDate: lastUpdate)
                        }
                    }
                    Spacer()
                    AlertsChartView(regionId: selectedRegionState)
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 5)
                .sheet(isPresented: $showRegion) {
                    SelectRegionView()
                }
                .task(id: selectedRegion) {
                    completion = false

                    appDelegate.setRegionId(selectedRegion)
                    appDelegate.registerForPushNotifications()

                    if let region = await getRegionStatus(selectedRegion) {
                        status = region.activeAlerts ?? []
                        lastUpdate = region.lastUpdate
                        completion = true
                    }
                }
                HStack {
                    HStack(spacing: 5) {
                        Text(regionName.replacingOccurrences(of: "територіальна громада", with: "ТГ"))
                            .lineLimit(1)
                        Image(systemName: "location.fill")
                    }
                    .font(.system(.body))
                    Spacer(minLength: 30)
                    Button {
                        showRegion.toggle()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(Color.primary)
                            .font(.system(.title3))
                    }
                }
                .padding(10)
            }
        }
    }
}

func getRegionStatus(_ regionId: String) async -> AlertRegionModel? {
    let regionStatusResponse = try? await Client.shared.send(Paths.alerts.regionID(regionId).get)
    let region = regionStatusResponse!.value.last!
    
    return region
}


//struct HomeScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreenView()
//    }
//}
