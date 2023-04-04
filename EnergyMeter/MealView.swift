import SwiftUI

struct MealView: View {
    @State private var selectedMeal: String = "Breakfast"
    @State var currentTime = Date()
    @State private var healthValue: Double = 3
    @State private var mealsize: Double = 3
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView{
                    VStack {
                            RoundedRectangle(cornerRadius: 10)
                            .fill(Color.teal).opacity(0.7)
                                .frame(width: 350,height: 75)
                                .overlay(
                                    VStack {
                                        Text("Meal logging").font(.custom("Poppins", size: 25))
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
                                    Text("Timestamp")
                                        .font(.custom("Poppins", size: 25))
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
                        .frame(width: 350,height: 150)
                        .overlay(
                            VStack {
                                Text("What did you eat?")
                                    .font(.custom("Poppins", size: 25))
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                    .padding()
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green)
                                    .frame(width: 150,height: 50)
                                    .overlay(
                                        VStack {
                                            Picker("Select meal", selection: $selectedMeal) {
                                                Text("Breakfast").tag("Breakfast")
                                                Text("Lunch").tag("Lunch")
                                                Text("Dinner").tag("Dinner")
                                                Text("Snack").tag("Snack")
                                            }
                                            .pickerStyle(.menu)
                                            .padding()
                                        })
                            }
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 350,height: 200)
                        .overlay(
                            VStack {
                                Text("Healthiness")
                                    .font(.custom("Poppins", size: 25))
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                    .padding(.bottom)
                                
                                CustomSlider(value: $healthValue)
                            }
                        ).padding()
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 350,height: 200)
                        .overlay(
                            VStack {
                                Text("Meal size")
                                    .font(.custom("Poppins", size: 25))
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                    .padding(.bottom)
                                
                                CustomSlider2(value: $mealsize)
                            }
                        )
                    Button(action: {
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
}

struct CustomSlider: View {
    @Binding var value: Double
    
    var body: some View {
        VStack {
            Slider(value: $value, in: 1...5, step: 1)
                .accentColor(.green)
                .padding(.horizontal)
            
            HStack {
                Text("Unhealthy")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium, design: .default))
                Spacer()
                Text("Healthy")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium, design: .default))
            }
            .padding(.horizontal)
        }
    }
}

struct CustomSlider2: View {
    @Binding var value: Double
    
    var body: some View {
        VStack {
            Slider(value: $value, in: 1...5, step: 1)
                .accentColor(.green)
                .padding(.horizontal)
            
            HStack {
                Text("Small")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium, design: .default))
                Spacer()
                Text("Large")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium, design: .default))
            }
            .padding(.horizontal)
        }
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView()
    }
}
