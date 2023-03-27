import SwiftUI


struct LoggingView: View {
    @State private var elevel: Double = 2.5
    @State var currentTime = Date()
    var closedRange = Calendar.current.date(byAdding: .year, value: -1, to: Date())!

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack {
                    /*
                    Section(header:Text("Timestamp").font(.custom("Poppins", size: 32))
                            .fontWeight(.medium)
                            .foregroundColor(.black))
                    {*/
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
                    /*}*/
                    .padding()
                }
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 350,height: 350)
                    .overlay(
                        VStack {
                            Text("How is your energy level?")
                                .font(.system(size: 32, weight: .medium, design:  .default))
                                .foregroundColor(.black)
                                .padding()
                            
                            Slider(value: $elevel, in: 0...5)
                                .padding()
                            
                            Text("\(elevel, specifier: "%.1f")")
                                .padding()
                            
                            
                        }
                        )
                Button(action: {
                    // Add logging functionality here
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


struct LoggingView_Previews: PreviewProvider {
    static var previews: some View {
        LoggingView()
    }
}
