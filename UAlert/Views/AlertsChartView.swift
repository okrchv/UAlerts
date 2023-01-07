//
//  AlertsChartView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 20.10.2022.
//

import Foundation
import SwiftUI
import UkraineAlertAPI

typealias AlertMap = [AlertType: Int]
typealias DayMap = [Date: AlertMap]

struct AlertsChartView: View {
    @State var completion = false
    @State var pollDays: [PollDay] = []
    
    var regionId: String
    var daysCount: Int = 7

    var body: some View {
        VStack(alignment: .center) {
            
            HStack(spacing: 5) {
                Image(systemName: "chart.bar")
                Text(LocalizedStringKey("Alerts statistics"))
                    .textCase(.uppercase)
                Spacer()
            }
            .font(.system(.footnote))
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
                        
            VStack {
                if completion == true {
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(pollDays, id: \.date) { day in
                            VStack(spacing: 0) {
                                ForEach(AlertType.allCases, id: \.rawValue) { type in
                                    ZStack {
                                        if day.alerts.isEmpty {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 25, height: 0.5)
                                        } else if let count = day.alerts[type] {
                                            Rectangle()
                                                .fill(barColors[type]!)
                                                .frame(width: 25, height: CGFloat(count) * 20.0)
                                            Text(String(count))
                                                .font(.system(.footnote))
                                                .foregroundColor(Color.white)
                                                .rotationEffect(.degrees(-90))
                                        }
                                    }
                                }
                                Text("\(day.date.formatted(.dateTime.weekday(.short)))")
                                    .font(.footnote)
                                    .frame(height: 20)
                            }
                        }
                    }
                } else {
                    ProgressView()
                        .padding()
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .task(id: regionId) {
            completion = false
            
            if let allAlertsHistory = await getAllAlertsHistory() {
                pollDays = alertsHistoryToPollDays(allAlertsHistory, regionId, daysCount)
                completion = true
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsChartView(regionId: "9")
    }
}

let barColors = [
    AlertType.unknown: Color.gray,
    AlertType.info: Color.blue,
    AlertType.artillery: Color.orange,
    AlertType.urbanFights: Color.brown,
    AlertType.nuclear: Color.black,
    AlertType.chemical: Color.green,
    AlertType.air: Color.red
]

func getAllAlertsHistory() async -> [StateAlarmsHolder]? {
    let regionHistoryResponse = try? await Client.shared.send(Paths.alerts.allHistory.get)
    let regionHistory = regionHistoryResponse?.value ?? nil
    
    return regionHistory
}

func alertsHistoryToPollDays(_ allAlertsHistory: [StateAlarmsHolder], _ regionID: String, _ daysCount: Int) -> [PollDay] {
    let selectedRegion = allAlertsHistory.first(where: { $0.regionID == regionID })

    let todayStart = Calendar.current.startOfDay(for: Date.now)
    let endDate = Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!
    let startDate = Calendar.current.date(byAdding: .day, value: -1 * daysCount - 1, to: endDate)!
    
    let dateInterval = DateInterval(start: startDate, end: endDate)
    
    let dayMap = selectedRegion!.alarms!.reduce(into: DayMap()) { dayMap, alarm in
        if (dateInterval.contains(alarm.startDate!)) {
            let date = Calendar.current.startOfDay(for: alarm.startDate!)
                                
            if (dayMap[date] == nil) { dayMap[date] = AlertMap() }
            
            if (dayMap[date]![alarm.alertType!] == nil) {
                dayMap[date]![alarm.alertType!] = 1
            } else {
                dayMap[date]![alarm.alertType!]! += 1
            }
        }
    }
    
    let days = 0...daysCount
    
    return days.map { dayNumber -> PollDay in
        let date = Calendar.current.date(byAdding: .day, value: dayNumber, to: dateInterval.start)!

        if let alertMap = dayMap[date] {
            return PollDay(date: date, alerts: alertMap)
        } else {
            return PollDay(date: date, alerts: AlertMap())
        }
    }
}
