import SwiftUI

struct ContentView: View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


