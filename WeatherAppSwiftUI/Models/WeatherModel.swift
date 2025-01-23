//
//  WeatherModel.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 20/01/2025.
//

import Foundation

struct OneCallWeatherData: Codable {
    let current: CurrentWeatherModel
    let daily: [DailyWeatherModel]
}

struct CurrentWeatherModel: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct DailyWeatherModel: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: DailyTemp
    let feels_like: DailyFeelsLike
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let uvi: Double
}

struct DailyTemp: Codable {
    let day, min, max, night, eve, morn: Double
}

struct DailyFeelsLike: Codable {
    let day, night, eve, morn: Double
}

// Keep the existing Weather model as it is used in both current and daily data
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
