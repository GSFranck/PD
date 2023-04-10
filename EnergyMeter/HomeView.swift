import SwiftUI
import AAInfographics

enum TimeFrame: String, CaseIterable {
    case Week, Month, Year
}

struct EnergyData: Codable {
    let date: Date
    let value: Double
}

struct HomeView: View {
    @State var selection: TimeFrame = .Week
    @State private var elevel: Double = 2.5
    @State private var energyLevels: [EnergyData] = []

    private var filteredEnergyLevels: [EnergyData] {
        let currentDate = Date()
        let filtered: [EnergyData]

        switch selection {
        case .Week:
            filtered = energyLevels.filter { energyData in
                let interval = currentDate.timeIntervalSince(energyData.date)
                return interval <= (7 * 24 * 60 * 60)
            }
        case .Month:
            filtered = energyLevels.filter { energyData in
                let interval = currentDate.timeIntervalSince(energyData.date)
                return interval <= (31 * 24 * 60 * 60)
            }
        case .Year:
            filtered = energyLevels.filter { energyData in
                let interval = currentDate.timeIntervalSince(energyData.date)
                return interval <= (365 * 24 * 60 * 60)
            }
        }
        return filtered
    }

    var body: some View {
        VStack {
            
            ScrollView {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 370, height: 500)
                    .overlay(
                        VStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.teal).opacity(0.7)
                                .frame(width: 350,height: 75)
                                .overlay(
                                    VStack {
                                        Text("Overview").font(.custom("Poppins", size: 25))
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                    }
                                )
                        
                            if !filteredEnergyLevels.isEmpty {
                                TimestampLineChartView(data: filteredEnergyLevels.map { ($0.date.timeIntervalSince1970, $0.value) })
                                    .frame(height: 300)
                                    .padding()
                                    .cornerRadius(10)
                            } else {
                                Text("No data available")
                                    .foregroundColor(.gray)
                                    .padding(10)
                            }

                            Picker("Select Timeframe", selection: $selection) {
                                ForEach(TimeFrame.allCases, id: \.self) {
                                    timeframe in Text(timeframe.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                            //.padding(.vertical)
                        })
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 370, height: 260)
                    .overlay(
                        VStack {
                            Text("Energy level")
                                .font(.system(size: 32, weight: .medium, design: .default))
                                .foregroundColor(.black)
                            Slider(value: $elevel, in: 0...5).padding()
                            Text("\(elevel, specifier: "%.1f")")
                            Button(action: {
                                energyLevels.append(EnergyData(date: Date(), value: elevel))
                                UserDefaults.standard.set(try? PropertyListEncoder().encode(energyLevels), forKey: "energyLevels")
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
        }
        .onAppear {
            if let data = UserDefaults.standard.data(forKey: "energyLevels"),
               let savedLevels = try? PropertyListDecoder().decode([EnergyData].self, from: data) {
                energyLevels = savedLevels
            }
        }
    }
}
struct TimestampLineChartView: UIViewRepresentable {
    typealias UIViewType = AAChartView

    var data: [(TimeInterval, Double)]

    func makeUIView(context: Context) -> AAChartView {
        let chartView = AAChartView()
        chartView.aa_drawChartWithChartModel(chartModel())
        return chartView
    }

    func updateUIView(_ uiView: AAChartView, context: Context) {
        uiView.aa_refreshChartWholeContentWithChartModel(chartModel())
    }

    private func chartModel() -> AAChartModel {
        let series = AASeriesElement()
            .name("Energy Level")
            .data(data.map { [$0.0, $0.1] })
            .color("#00BFFF")
            .lineWidth(3)

        return AAChartModel()
            .chartType(.line)
            .animationType(.easeOutQuart)
            //.title("Energy Level")
            //.subtitle("Timestamp")
            //.yAxisTitle("Energy Level")
            .categories(data.map { _ in "" }) // Hide x-axis categories
            .series([series])
            .xAxisLabelsEnabled(false) // Hide x-axis labels
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
