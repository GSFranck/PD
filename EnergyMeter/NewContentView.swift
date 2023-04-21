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
            MealView()
                .tabItem {
                    Label("Meal", systemImage: "cup.and.saucer.fill")
                }
        }
    }
}


struct NewContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewContentView()
    }
}
