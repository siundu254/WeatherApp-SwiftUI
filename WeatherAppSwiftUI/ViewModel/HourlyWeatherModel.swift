//
//  HourlyWeatherModel.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 25/01/2025.
//

import Foundation

struct WeatherForecast: Codable {
    let list: [HourlyData]
}

struct HourlyData: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
}

struct HourlyWeatherModel: Identifiable, Codable {
    let id = UUID()
    let time: Date
    let temperature: Double
    let weather: Weather
    
    enum CodingKeys: String, CodingKey {
        case time, temperature, weather
    }
    
    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try container.decode(Date.self, forKey: .time)
        self.temperature = try container.decode(Double.self, forKey: .temperature)
        self.weather = try container.decode(Weather.self, forKey: .weather)
    }
    
    // Custom initializer for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(time, forKey: .time)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(weather, forKey: .weather)
    }
    
    // Optional: If you want to initialize from HourlyData:
    init?(from data: HourlyData) {
        let time = Date(timeIntervalSince1970: TimeInterval(data.dt))
        self.time = time
        self.temperature = data.main.temp
        self.weather = data.weather.first ?? Weather(id: 0, main: "Unknown", description: "Unknown", icon: "01d")
    }
}
