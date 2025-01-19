//
//  MockCarService.swift
//  AutomarketTests
//
//  Created by Oleg Granchenko on 30.12.2024.
//

@testable import Automarket

import Foundation

class MockCarService: CarServiceProtocol {
    var result: Result<[Car], Error> = .success([])

    func fetchCars() async throws -> [Car] {
        switch result {
        case .success(let cars):
            return cars
        case .failure(let error):
            throw error
        }
    }
}
