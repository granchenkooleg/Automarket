//
//  APIService.swift
//  Automarket
//
//  Created by Oleg Granchenko on 30.12.2024.
//

import Foundation
import Combine

enum CarServiceError: Error {
    case invalidResponse
    case decodingError
    case networkError(Error)
}

protocol CarServiceProtocol {
    func fetchCars() async throws -> [Car]
}

final class CarService: CarServiceProtocol {
    private let url: URL
    private let session: URLSession

    init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    func fetchCars() async throws -> [Car] {
        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CarServiceError.invalidResponse
            }

            let decoder = JSONDecoder()
            do {
                let cars = try decoder.decode([Car].self, from: data)
                return cars
            } catch {
                throw CarServiceError.decodingError
            }

        } catch {
            throw CarServiceError.networkError(error)
        }
    }
}
