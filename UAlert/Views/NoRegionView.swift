//
//  NoRegionView.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 13.12.2022.
//

import SwiftUI

struct NoRegionView: View {    
    @State var showRegions = false
        
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
            Spacer()
            Image(systemName: "location.slash.fill")
                .font(.system(size: 100))
                .foregroundColor(.accentColor)
            Text(LocalizedStringKey("UAlerts is unavailable"))
                .font(.system(.title2))
            Text(LocalizedStringKey("Please select region to continue"))
                .font(.system(.subheadline))
                .foregroundColor(.secondary)
            Spacer()
            Button(LocalizedStringKey("Select Region")) {
                showRegions.toggle()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.accentColor)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
            Spacer()
        }
        .sheet(isPresented: $showRegions) {
            SelectRegionView()
        }
    }
}

struct NoRegionView_Previews: PreviewProvider {
    static var previews: some View {
        NoRegionView()
    }
}
