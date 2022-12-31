//
//  SettingsView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 29.11.2022.
//

import UkraineAlertAPI
import SwiftUI

struct SettingsRegion: Hashable {
    var id: String
    var name: String
    var childRegions: [SettingsRegion]?
}

struct SelectRegionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss

    @State var allRegions: [SettingsRegion] = []
    @State var selected: SettingsRegion?

    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(allRegions, id: \.self) { region in
                        if let communities = region.childRegions {
//                            NavigationLink(region.name) {
//                                List {
//                                    ForEach(communities, id: \.self) { community in
//                                        Text(community.name)
//                                    }
//                                }
//                                .navigationTitle("Communities")
//                            }
                            Section(header: Text(region.name)) {
                                ForEach(communities, id: \.self) { community in
                                    HStack {
                                        Text(community.name)
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                    .listRowBackground((community.id == selected?.id) ? Color.gray.opacity(0.2) : Color.white.opacity(0.45))
                                    .onTapGesture {
                                        withAnimation {
                                            selected = community
                                            UserDefaults.standard.set(region.id, forKey: "userRegionIdState")
                                            UserDefaults.standard.set(community.id, forKey: "userRegionId")
                                            UserDefaults.standard.set(community.name, forKey: "userRegionName")
                                            dismiss()
                                        }
                                    }
                                }
                            }
                        } else {
                            HStack {
                                Text(region.name)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .listRowBackground((region.id == selected?.id) ? Color.gray.opacity(0.2) : Color.white.opacity(0.45))
                            .onTapGesture {
                                withAnimation {
                                    selected = region
                                    UserDefaults.standard.set(region.id, forKey: "userRegionIdState")
                                    UserDefaults.standard.set(region.id, forKey: "userRegionId")
                                    UserDefaults.standard.set(region.name, forKey: "userRegionName")
                                    dismiss()
                                }
                            }
                        }
                    }
                    .navigationBarTitle(LocalizedStringKey("Regions"))
                }
            }
        }
        .task {
            allRegions = await getAllRegions()
        }
    }
}

struct SettingsView: View {
    @AppStorage("userRegionName") private var regionName = ""

    @State var showShape = false
    @State var showRegions = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("Region"))) {
                    HStack {
                        if let name = regionName {
                            Text(name)
                        } else {
                            Text(LocalizedStringKey("No Region"))
                        }
                        Spacer()
                        Button(LocalizedStringKey("Change")) {
                            showRegions.toggle()
                        }
                    }
                }
            }
            .navigationBarTitle(LocalizedStringKey("Settings"))
        }
        .sheet(isPresented: $showRegions) {
            SelectRegionView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

func getAllRegions() async -> [SettingsRegion] {
    let response = try? await Client.shared.send(Paths.regions.get)
    let states = response?.value.states ?? []
    
    let sorted: [SettingsRegion] = states
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
                let region = SettingsRegion(id: state.regionID!, name: state.regionName!, childRegions: nil)
                return region
            }
            let communities: [SettingsRegion] = districts.flatMap { district in
                return district.regionChildIDs?.compactMap { community in
                    SettingsRegion(id: community.regionID!, name: community.regionName!, childRegions: nil)
                }
                ?? [SettingsRegion(id: district.regionID!, name: district.regionName!, childRegions: nil)]
            }
            return SettingsRegion(id: state.regionID!, name: state.regionName!, childRegions: communities)
        }
    return sorted
}
