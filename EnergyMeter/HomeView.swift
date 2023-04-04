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
    @State private var elevel: Double = 2.5
    var body: some View {

        VStack {
            ScrollView {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 370,height: 400)
                    .overlay(
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
                            .padding(.horizontal)
                            .padding(.vertical)                        })
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 370,height: 260)
                    .overlay(
                        VStack {
                            Text("Energy level")
                                .font(.system(size: 32, weight: .medium, design:  .default))
                                .foregroundColor(.black)
                            Slider(value: $elevel, in: 0...5).padding()
                            Text("\(elevel, specifier: "%.1f")")
                            Button(action: {
                            }) {
                                Text("Log")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: 200)
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .padding()
                            }
                        }
                    )
                
            }
            .withGradientBackground()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}







