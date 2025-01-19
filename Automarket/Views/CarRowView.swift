//
//  CarRowView.swift
//  Automarket
//
//  Created by Oleg Granchenko on 31.12.2024.
//

import SwiftUI

struct CarRowView: View {
    let car: Car

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Car title (Make + Model)
            Text(car.fullCarName)
                .font(.headline)
                .lineLimit(1)

            // Image slider
            if !car.imageUrls.isEmpty {
                ImageSliderView(images: car.imageUrls)
                    .frame(height: 200)
                    .clipped()
            }

            // Price and Fuel
            HStack {
                Text(car.formattedPrice)
                    .font(.subheadline)

                Spacer()

                Text(car.fuel.fueldDescription)
                    .font(.subheadline)
                    .foregroundColor(car.fuel.fuelColor)
            }

            // Mileage and First Registration
            HStack {
                Text(car.formattedMileage)
                    .font(.subheadline)

                Spacer()

                Text("First Registered: \(car.formattedFirstRegistration)")
                    .font(.subheadline)
            }

            Text(car.carDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(3)

            // Seller Information
            VStack(alignment: .leading, spacing: 5) {
                Text("Seller Type: \(car.sellerType)")
                Text("City: \(car.sellerCity)")
                Text("Phone: \(car.sellerContact)")
            }
            .font(.subheadline)
        }
        .padding()
    }
}

struct CarRowView_Previews: PreviewProvider {
    static var previews: some View {
        CarRowView(
            car: Car(
                id: 1,
                make: "Toyota",
                model: "Camry",
                price: 25000,
                firstRegistration: "2018",
                mileage: 50000,
                fuel: .gasoline,
                images: [ImageURL(url: "https://example.com/car.jpg")],
                seller: Seller(
                    type: "Private",
                    phone: "1234567890",
                    city: "Kyiv"
                ),
                description: "A reliable family car."
            )
        )
    }
}
