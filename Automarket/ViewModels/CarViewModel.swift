//
//  CarListingsViewModel.swift
//  Automarket
//
//  Created by Oleg Granchenko on 30.12.2024.
//

import Foundation
import Combine

@MainActor
final class CarViewModel: ObservableObject {
    @Published var cars: [Car] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let carService: CarServiceProtocol

    init(carService: CarServiceProtocol) {
        self.carService = carService
    }

    func fetchCars() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedCars = try await carService.fetchCars()
            cars = fetchedCars
        } catch {
            errorMessage = mapErrorToMessage(error)
        }

        isLoading = false
    }

    private func mapErrorToMessage(_ error: Error) -> String {
        if let error = error as? URLError, error.code == .badServerResponse {
            return "Failed to load cars. Please try again later."
        } else if let error = error as? CarServiceError {
            switch error {
            case .invalidResponse:
                return "Invalid response from the server."
            case .decodingError:
                return "Failed to decode the data."
            case .networkError(let networkError):
                return "Network error: \(networkError.localizedDescription)"
            }
        } else {
            return "An unknown error occurred."
        }
    }
}
