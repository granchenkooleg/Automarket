//
//  CarListing.swift
//  Automarket
//
//  Created by Oleg Granchenko on 30.12.2024.
//

import Foundation
import SwiftUICore

struct Car: Identifiable, Equatable, Codable {
    let id: Int
    let make: String
    let model: String
    let price: Int
    let firstRegistration: String?
    let mileage: Int
    let fuel: FuelType
    let images: [ImageURL]?
    let seller: Seller?
    let description: String?

    // Conform to Equatable by comparing the unique id
    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.id == rhs.id
    }

    enum FuelType: String, Codable {
         case gasoline
         case diesel
         case electric
         case hybrid
         case unknown

         init(from decoder: Decoder) throws {
             let container = try decoder.singleValueContainer()
             let rawValue = try container.decode(String.self).lowercased()
             self = FuelType(rawValue: rawValue) ?? .unknown
         }

         var fueldDescription: String {
             switch self {
             case .gasoline: return "Gasoline"
             case .diesel: return "Diesel"
             case .electric: return "Electric"
             case .hybrid: return "Hybrid"
             case .unknown: return "Unknown"
             }
         }

         var fuelColor: Color {
             switch self {
             case .gasoline: return .blue
             case .diesel: return .green
             case .electric: return .yellow
             case .hybrid: return .purple
             case .unknown: return .gray
             }
         }
     }
}

struct ImageURL: Codable {
    let url: String
}

struct Seller: Codable {
    let type: String
    let phone: String
    let city: String
}

extension Car {

    // Format the price with a currency symbol and grouping for thousands
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "en_US")

        guard let formattedNumber = formatter.string(from: NSNumber(value: price)) else {
            return "$\(price)" // Fallback if formatting fails
        }

        // Add the currency symbol at the beginning
        return "$\(formattedNumber)"
    }

    // Convert mileage into a more readable format (e.g., "10,000 km")
    var formattedMileage: String {
        return "\(mileage) km"
    }

    // Format the first registration date or show a default message
    var formattedFirstRegistration: String {
        return firstRegistration ?? "N/A"
    }

    // Extract image URLs, or return an empty array if no images exist
    var imageUrls: [URL] {
        return images?.compactMap { URL(string: $0.url) } ?? []
    }

    // Return the full name of the car (make + model)
    var fullCarName: String {
        return "\(make) \(model)"
    }

    // Seller's contact number, formatted if needed
    var sellerContact: String {
        return seller?.phone ?? "N/A"
    }

    // Seller's city, or "Unknown" if not available
    var sellerCity: String {
        return seller?.city ?? "Unknown"
    }

    // Seller's type (e.g., "Dealer", "Private")
    var sellerType: String {
        return seller?.type ?? "N/A"
    }

    // A description of the car, defaulting to an empty string if nil
    var carDescription: String {
        return description ?? "No description available."
    }

    // The age of the car in years (based on first registration)
    var carAge: Int? {
        guard let firstRegistration = firstRegistration,
              let registrationYear = Int(firstRegistration.prefix(4)) else {
            return nil
        }
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - registrationYear
    }
}
