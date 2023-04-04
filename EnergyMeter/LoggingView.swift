import SwiftUI

struct LoggingView: View {
    @State private var elevel: Double = 2.5
    @State private var currentTime = Date()
    @AppStorage("loggedEntries") var loggedEntries: Data?

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.teal).opacity(0.7)
                        .frame(width: 350,height: 75)
                        .overlay(
                            VStack {
                                Text("Energy logging").font(.custom("Poppins", size: 25))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                        )
                }

                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 350,height: 125)
                        .overlay(
                            VStack {
                                Text("Timestamp").font(.custom("Poppins", size: 25))
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                DatePicker("Date:", selection: $currentTime)
                                    .labelsHidden()
                                    .padding(.horizontal)
                            }
                        )
                        .padding()
                }

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 350,height: 200)
                    .overlay(
                        VStack {
                            Text("How is your energy level?")
                                .font(.custom("Poppins", size: 25))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .padding()

                            Slider(value: $elevel, in: 0...5)
                                .padding()

                            Text("\(elevel, specifier: "%.1f")")
                                .padding()
                        }
                    )

                Button(action: {
                    // Store the timestamp and energy level in UserDefaults
                    let entry = LoggedEntry(timestamp: currentTime, energyLevel: elevel)
                    var entries = [LoggedEntry]()
                    if let data = loggedEntries, let savedEntries = try? JSONDecoder().decode([LoggedEntry].self, from: data) {
                        entries = savedEntries
                    }
                    entries.append(entry)
                    if let data = try? JSONEncoder().encode(entries) {
                        loggedEntries = data
                    }
                }) {
                    Text("Log")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding()
                }

                Spacer()
            }
        }
    }
}

struct LoggedEntry: Codable {
    let timestamp: Date
    let energyLevel: Double
}

struct LoggingView_Previews: PreviewProvider {
    static var previews: some View {
        LoggingView()
    }
}
