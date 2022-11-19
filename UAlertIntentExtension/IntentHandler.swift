//
//  IntentHandler.swift
//  UAlertIntentExtension
//
//  Created by Oleh Kiurchev on 22.08.2022.
//

import Intents
import UkraineAlertAPI
import SwiftUI

class IntentHandler: INExtension, AlarmStatusWidgetConfigIntentHandling  {
    func provideRegionOptionsCollection(for intent: AlarmStatusWidgetConfigIntent) async throws -> INObjectCollection<Region> {
        let regionsResponse = try await Client.shared.send(Paths.regions.get)
        let states = regionsResponse.value.states ?? []
        
        let sections: [INObjectSection<Region>] = states
            .sorted(by: { a, b in
                if a.regionID == "31" {
                    return true
                }
                
                return a.regionName!.compare(b.regionName!,
                                      options: .caseInsensitive,
                                      locale: Locale(identifier: "uk")) != .orderedDescending
            })
            .map { state in
                guard let districts = state.regionChildIDs,
                      !districts.isEmpty
                else {
                    let region = Region(identifier: state.regionID!, display: state.regionName!)
                    return INObjectSection<Region>(title: nil, items: [region])
                }
                
                let items: [Region] = districts.flatMap { district in
                    return district.regionChildIDs?.map { community in
                        Region(identifier: community.regionID!,
                               display: community.regionName!,
                               subtitle: district.regionName!,
                               image: nil
                        )
                    }
                    ?? [Region(identifier: district.regionID!, display: district.regionName!)]
                }

                return INObjectSection<Region>(title: state.regionName, items: items)
            }
        
        return INObjectCollection(sections: sections)
    }
}
