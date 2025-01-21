//
//  WeatherViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 20/01/2025.
//

import Combine
import CoreLocation
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherModel?
    @Published var forecast: ForecastModel?
    private var cancellables = Set<AnyCancellable>()
    let networkManager = NetworkManager()
    
    func fetchWeather(for coordinates: CLLocationCoordinate2D) {
        let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=YOUR_API_KEY&units=metric"
        let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=YOUR_API_KEY&units=metric"
        
        networkManager.fetch(WeatherModel.self, from: currentWeatherURL)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] data in
                self?.currentWeather = data
            })
            .store(in: &cancellables)
        
        networkManager.fetch(ForecastModel.self, from: forecastURL)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] data in
                self?.forecast = data
            })
            .store(in: &cancellables)
    }
}
