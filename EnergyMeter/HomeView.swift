import SwiftUI

enum TimeFrame: String, CaseIterable {
    case Day, Week, Month, Year
}

struct GradientBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

extension View {
    func withGradientBackground() -> some View {
        self.modifier(GradientBackgroundModifier())
    }
}

struct HomeView: View {
    @State var selection: TimeFrame = .Day
    var body: some View {
        NavigationView {
            VStack {
                Text("Average Energy Level").font(.system(size: 35))
                    .font(.system(size: 50))
                Image(information.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(10)
                Picker("Select Timeframe", selection: $selection) {
                    ForEach(TimeFrame.allCases, id: \.self) {
                        timeframe in Text(timeframe.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal) // Add some padding to the picker
            }
            .withGradientBackground() // Apply the custom modifier to the entire view
            
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Adjust the navigation view style to fix an issue in Xcode 13
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}







