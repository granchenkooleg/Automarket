//
//  ConfigManager.swift
//  Automarket
//
//  Created by Oleg Granchenko on 31.12.2024.
//

import Foundation

final class ConfigManager {
    private let carServiceURL: String
    
    init(carServiceURL: String) {
        self.carServiceURL = carServiceURL
    }
    
    // Get the service URL or provide a fallback URL
    func getServiceURL() -> URL? {
        guard let url = URL(string: Config.carServiceURL) else {
            // Log the error or handle it as necessary
            NSLog("Invalid URL in config: \(Config.carServiceURL)")
            return nil
        }
        return url
    }
}
