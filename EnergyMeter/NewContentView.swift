//
//  NewContentView.swift
//  EnergyMeter
//
//  Created by Gustav Franck on 27/03/2023.
//

import Foundation
import SwiftUI

struct NewContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home",systemImage: "person")
                }
            LoggingView()
                .tabItem {
                    Label("Logging", systemImage: "chart.bar.doc.horizontal")
                }
        }
        
    }
}

struct NewContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewContentView()
    }
}
