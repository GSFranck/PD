import SwiftUI
import Charts


enum TimeFrame: String, CaseIterable, Identifiable {
    case Day
    case Week

    var id: String { self.rawValue }

    var startDate: Date {
        let calendar = Calendar.current
        let now = Date()

        switch self {
        case .Day:
            return calendar.startOfDay(for: now)
        case .Week:
            return calendar.date(byAdding: .day, value: -7, to: now) ?? now
        }
    }
}
struct HomeView: View {
    @State var selection: TimeFrame = .Day
    @AppStorage("energyLevels") private var energyLevelsData: Data? {
        didSet {
            updateFilteredEnergyLevels()
        }
    }
    @AppStorage("mealEntries") private var mealEntriesData: Data? {
        didSet {
            updateFilteredEnergyLevels()
        }
    }

    private var energyLevels: [EnergyData] {
        (try? PropertyListDecoder().decode([EnergyData].self, from: energyLevelsData ?? Data())) ?? []
    }

    private var meals: [MealData] {
        (try? JSONDecoder().decode([MealData].self, from: mealEntriesData ?? Data())) ?? []
    }

    @State private var filteredEnergyLevels: [EnergyData] = []

    private func updateFilteredEnergyLevels() {
        let startDate = selection.startDate
        filteredEnergyLevels = energyLevels.filter { $0.date >= startDate }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 370, height: 500)
                        .overlay(
                            VStack {
                                
                                VStack {
                                    Text("Overview").font(.custom("Poppins", size: 35))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                                
                                if !filteredEnergyLevels.isEmpty {
                                    TimestampLineChartView(data: filteredEnergyLevels.map { ($0.date.timeIntervalSince1970, $0.value) }, mealData: meals)
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
                                
                            })
                }
            }
        }
    }
}
class MealEntryOverlayView: UIView {
    var mealData: [MealData] = []
    weak var chartView: LineChartView?

    init(mealData: [MealData], chartView: LineChartView) {
        self.mealData = mealData
        self.chartView = chartView
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext(), let chartView = chartView else { return }

        for meal in mealData {
            let color: UIColor
            switch meal.mealType {
            case "Breakfast":
                color = .orange
            case "Lunch":
                color = .green
            case "Dinner":
                color = .red
            case "Snack":
                color = .purple
            default:
                color = .black
            }

            let xValue = meal.timestamp.timeIntervalSince1970
            let xPos = chartView.getTransformer(forAxis: .left).pixelForValues(x: xValue, y: 0).x
            let width = CGFloat(meal.mealSize * 2)

            context.setLineWidth(width)
            context.setStrokeColor(color.cgColor)
            context.move(to: CGPoint(x: xPos, y: chartView.viewPortHandler.contentTop))
            context.addLine(to: CGPoint(x: xPos, y: chartView.viewPortHandler.contentBottom))
            context.drawPath(using: .stroke)
        }
    }

}

struct TimestampLineChartView: UIViewRepresentable {
    typealias UIViewType = UIView

    var data: [(TimeInterval, Double)]
    var mealData: [MealData]

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let chartView = LineChartView()
        chartView.data = lineData()

        // Remove the grid from the background
        chartView.gridBackgroundColor = .clear
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false

        // Remove the timestamp tickmarks
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false

        // Add a legend for meal types
        chartView.legend.extraEntries = mealTypeLegendEntries()

        // Set fixed tick marks for the y-axis
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = 5
        chartView.leftAxis.setLabelCount(6, force: true)
        
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.axisMaximum = 5
        chartView.rightAxis.setLabelCount(6, force: true)

        let overlayView = MealEntryOverlayView(mealData: mealData, chartView: chartView)

        container.addSubview(overlayView)
        container.addSubview(chartView)

        chartView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: container.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            overlayView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: container.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }



    func updateUIView(_ uiView: UIView, context: Context) {
        if let chartView = uiView.subviews.first as? LineChartView {
            chartView.data = lineData()
        }

        if let overlayView = uiView.subviews.last as? MealEntryOverlayView {
            overlayView.chartView = uiView.subviews.first as? LineChartView
            overlayView.mealData = mealData
            overlayView.setNeedsDisplay()
        }
    }

    private func mealTypeLegendEntries() -> [LegendEntry] {
        let legendColors: [NSUIColor] = [.orange, .green, .red, .purple]
        let legendLabels = ["Breakfast", "Lunch", "Dinner", "Snack"]

        return zip(legendColors, legendLabels).map { color, label in
            let entry = LegendEntry()
            entry.label = label
            entry.form = .default
            entry.formSize = CGFloat.nan
            entry.formLineWidth = 10
            entry.formLineDashPhase = CGFloat.nan
            entry.formLineDashLengths = nil
            entry.formColor = color
            return entry
        }
    }


    private func lineData() -> LineChartData {
        let energyEntries = data.map { ChartDataEntry(x: $0.0, y: $0.1) }
        let energyDataSet = LineChartDataSet(entries: energyEntries, label: "Energy Level")
        energyDataSet.setColor(.systemBlue)
        energyDataSet.lineWidth = 3
        energyDataSet.drawValuesEnabled = false

        return LineChartData(dataSets: [energyDataSet])
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
