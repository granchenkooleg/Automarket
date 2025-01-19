//
//  AutomarketTests.swift
//  AutomarketTests
//
//  Created by Oleg Granchenko on 30.12.2024.
//

import XCTest
@testable import Automarket

final class CarViewModelTests: XCTestCase {
    var carViewModel: CarViewModel!
    var mockCarService: MockCarService!

    override func setUp() async throws {
        try await super.setUp()
        mockCarService = MockCarService()
        carViewModel = await MainActor.run {
            CarViewModel(carService: mockCarService)
        }
    }

    override func tearDown() async throws {
        carViewModel = nil
        mockCarService = nil
        try await super.tearDown()
    }

    func testFetchCarsSuccess() async {
        // Given
        let mockCars = [
            Car(
                id: 1,
                make: "BMW",
                model: "316i",
                price: 13000,
                firstRegistration: "01-2000",
                mileage: 25000,
                fuel: .gasoline,
                images: [],
                seller: nil,
                description: nil
            )
        ]
        mockCarService.result = .success(mockCars)

        // When
        await carViewModel.fetchCars()

        // Then
        await MainActor.run {
            XCTAssertFalse(carViewModel.isLoading, "isLoading should be false after fetching data.")
            XCTAssertNil(carViewModel.errorMessage, "errorMessage should be nil on success.")
            XCTAssertEqual(carViewModel.cars, mockCars, "Cars should match the mock data.")
        }
    }

    func testFetchCarsFailure() async {
        // Given
        mockCarService.result = .failure(URLError(.badServerResponse))

        // When
        await carViewModel.fetchCars()

        // Then
        await MainActor.run {
            XCTAssertFalse(carViewModel.isLoading, "isLoading should be false after fetching data.")
            XCTAssertEqual(carViewModel.errorMessage, "Failed to load cars. Please try again later.", "errorMessage should match the failure message.")
            XCTAssertTrue(carViewModel.cars.isEmpty, "Cars should be empty on failure.")
        }
    }

    func testFetchCarsLoadingState() async {
        // Given
        let mockCar = Car(
            id: 1,
            make: "Audi",
            model: "A4",
            price: 30000,
            firstRegistration: "2021-01-01",
            mileage: 15000,
            fuel: .diesel,
            images: [ImageURL(url: "https://example.com/car1.jpg")],
            seller: Seller(type: "Dealer", phone: "123456789", city: "Berlin"),
            description: "A great car in excellent condition."
        )

        mockCarService.result = .success([mockCar])

        // When
        let fetchTask = Task {
            await carViewModel.fetchCars()
        }

        // Then
        await MainActor.run {
            XCTAssertTrue(carViewModel.cars.isEmpty, "Cars should be empty before the fetch completes.")
        }

        // Wait for the task to complete
        await fetchTask.value

        // Verify that cars are populated after the fetch
        await MainActor.run {
            XCTAssertFalse(carViewModel.cars.isEmpty, "Cars should be populated after the fetch.")
            XCTAssertEqual(carViewModel.cars.first?.make, "Audi", "First car's make should be 'Audi'.")
            XCTAssertEqual(carViewModel.cars.first?.model, "A4", "First car's model should be 'A4'.")
            XCTAssertEqual(carViewModel.cars.first?.price, 30000, "First car's price should be 30000.")

            // Assert that the formatted price is correct
            let formattedPrice = carViewModel.cars.first?.formattedPrice
            XCTAssertEqual(formattedPrice, "$30,000", "Formatted price should be '$30,000'.")

            // Assert that the formatted mileage is correct
            let formattedMileage = carViewModel.cars.first?.formattedMileage
            XCTAssertEqual(formattedMileage, "15000 km", "Formatted mileage should be '15000 km'.")

            // Assert that the fuel description is correct
            let fuelDescription = carViewModel.cars.first?.fuel.fueldDescription
            XCTAssertEqual(fuelDescription, "Diesel", "Fuel description should be 'Diesel'.")

            // Assert that the car description is correct
            let carDescription = carViewModel.cars.first?.carDescription
            XCTAssertEqual(carDescription, "A great car in excellent condition.", "Car description should match the given description.")

            // Optionally, check other computed properties
            let sellerType = carViewModel.cars.first?.sellerType
            XCTAssertEqual(sellerType, "Dealer", "Seller type should be 'Dealer'.")

            // Check the seller's contact number
            let sellerContact = carViewModel.cars.first?.sellerContact
            XCTAssertEqual(sellerContact, "123456789", "Seller's phone number should be '123456789'.")
        }
    }
}
