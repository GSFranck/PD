
import SwiftUI

enum TimeFrame: String, CaseIterable {
    case Day, Week, Month, Year
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
                    .padding(40)
                Picker("Select Timeframe", selection: $selection) {
                    ForEach(TimeFrame.allCases, id: \.self) {
                        timeframe in Text(timeframe.rawValue)
                    }
                }
            }.pickerStyle(.segmented)
        }.navigationTitle("Average level").padding()
       
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}








/*VStack {
    Text("All About")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding()

    Image(information.image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .cornerRadius(10)
        .padding(40)
}*/
