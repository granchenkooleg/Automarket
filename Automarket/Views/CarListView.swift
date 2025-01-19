//
//  CarListView.swift
//  Automarket
//
//  Created by Oleg Granchenko on 31.12.2024.
//

import SwiftUI

struct CarListView: View {
    @ObservedObject var carViewModel: CarViewModel

    init(viewModel: CarViewModel) {
        self.carViewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ZStack {
                if carViewModel.isLoading {
                    ProgressView("Loading cars...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    List(carViewModel.cars) { car in
                        CarRowView(car: car)
                            .padding(.vertical, 10)
                    }
                    .listStyle(PlainListStyle())
                }

                if let errorMessage = carViewModel.errorMessage {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all) // Dim background
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("Cars")
            .task {
                if carViewModel.cars.isEmpty {
                    await carViewModel.fetchCars()
                }
            }
        }
    }
}


struct CarListView_Previews: PreviewProvider {
    static var previews: some View {
        let carService = MockCarService()
        let carViewModel = CarViewModel(carService: carService)
        return CarListView(viewModel: carViewModel)
    }
}

class MockCarService: CarServiceProtocol {
    func fetchCars() async -> [Car] {
        return [
            Car(
                id: 1,
                make: "Toyota",
                model: "Corolla",
                price: 15000,
                firstRegistration: "2019",
                mileage: 30000,
                fuel: .gasoline,
                images: nil,
                seller: nil,
                description: "A reliable car with good fuel economy."
            ),
            Car(
                id: 2,
                make: "Tesla",
                model: "Model 3",
                price: 35000,
                firstRegistration: "2022",
                mileage: 15000,
                fuel: .electric,
                images: nil,
                seller: nil,
                description: "An electric car with amazing performance."
            ),
            Car(
                id: 3,
                make: "BMW",
                model: "X5",
                price: 50000,
                firstRegistration: "2020",
                mileage: 25000,
                fuel: .diesel,
                images: nil,
                seller: nil,
                description: "A luxury SUV with a comfortable ride."
            )
        ]
    }
}




