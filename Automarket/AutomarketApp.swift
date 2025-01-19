//
//  AutomarketApp.swift
//  Automarket
//
//  Created by Oleg Granchenko on 30.12.2024.
//

import SwiftUI

@main
struct AutomarketApp: App {
    private let configManager = ConfigManager(carServiceURL: Config.carServiceURL)
    
    var body: some Scene {
        WindowGroup {
            if let url = configManager.getServiceURL() {
                CarListView(viewModel: CarViewModel(carService: CarService(url: url)))
            } else {
                // Show an error view if the URL is invalid
                ErrorView()
            }
        }
    }
}
