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
    @Published var currentWeather: CurrentWeatherModel?
    @Published var forecast: ForecastListModel?
    @Published var hourlyForecast: [HourlyWeatherModel] = []
    @Published var lastUpdated: Date?
    @Published var favorites: [CLLocationWrapper] = []
    
    private var cancellables = Set<AnyCancellable>()
    let networkManager = NetworkManager()
    
    init() {
        self.lastUpdated = loadLastUpdatedDate()
        if !isDataFresh() {
            loadFromUserDefaults()
        }
        loadFavorites()
    }
    
    func fetchWeather(for coordinates: CLLocationCoordinate2D, completion: @escaping () -> Void) {
        let currentWeatherURL = "https://api.openweathermap.org/data/3.0/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=6ff7eaa81849ec2c936e3c0f1863ae99&units=metric&exclude=minutely,hourly,alerts"
        
        networkManager.fetch(OneCallWeatherData.self, from: currentWeatherURL)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] data in
                self?.currentWeather = data.current
                self?.forecast = self?.createForecastListModel(from: data.daily)
                self?.fetchHourlyWeather(latitude: coordinates.latitude, longitude: coordinates.longitude) {
                    self?.saveToUserDefaults()
                    self?.lastUpdated = Date()
                    self?.saveLastUpdatedDate()
                    completion()
                }
            })
            .store(in: &cancellables)
    }
    
    private func fetchHourlyWeather(latitude: Double, longitude: Double, completion: @escaping () -> Void) {
        let hourlyWeatherURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=6ff7eaa81849ec2c936e3c0f1863ae99&units=metric"
        
        networkManager.fetch(WeatherForecast.self, from: hourlyWeatherURL)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] forecastData in
                self?.hourlyForecast = forecastData.list.compactMap { HourlyWeatherModel(from: $0) }
                completion()
            })
            .store(in: &cancellables)
    }
    
    private func createForecastListModel(from daily: [DailyWeatherModel]) -> ForecastListModel? {
        guard daily.count > 1 else { return nil }
        let forecastDays = Array(daily.dropFirst())
        return ForecastListModel(list: forecastDays)
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(currentWeather), forKey: "currentWeather")
        UserDefaults.standard.set(try? JSONEncoder().encode(forecast), forKey: "forecast")
        UserDefaults.standard.set(try? JSONEncoder().encode(hourlyForecast), forKey: "hourlyForecast")
    }
    
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "currentWeather") {
            self.currentWeather = try? JSONDecoder().decode(CurrentWeatherModel.self, from: data)
        }
        if let data = UserDefaults.standard.data(forKey: "forecast") {
            self.forecast = try? JSONDecoder().decode(ForecastListModel.self, from: data)
        }
        if let data = UserDefaults.standard.data(forKey: "hourlyForecast") {
            self.hourlyForecast = (try? JSONDecoder().decode([HourlyWeatherModel].self, from: data)) ?? []
        }
    }
    
    public func isDataFresh() -> Bool {
        guard let lastUpdated = lastUpdated else { return false }
        return Date().timeIntervalSince(lastUpdated) < 3600
    }
    
    private func saveLastUpdatedDate() {
        UserDefaults.standard.set(lastUpdated, forKey: "LastWeatherUpdate")
    }
    
    private func loadLastUpdatedDate() -> Date? {
        return UserDefaults.standard.object(forKey: "LastWeatherUpdate") as? Date
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let locations = try? JSONDecoder().decode([CLLocationWrapper].self, from: data) {
            self.favorites = locations
        }
    }
    
    func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }
    
    func addToFavorites(_ location: CLLocation) {
        let wrapper = CLLocationWrapper(from: location)
        if !favorites.contains(where: { $0.latitude == wrapper.latitude && $0.longitude == wrapper.longitude }) {
            favorites.append(wrapper)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(_ location: CLLocation) {
        let wrapper = CLLocationWrapper(from: location)
        favorites.removeAll { $0.latitude == wrapper.latitude && $0.longitude == wrapper.longitude }
        saveFavorites()
    }
    
    func isLocationFavorited(_ location: CLLocation) -> Bool {
        let wrapper = CLLocationWrapper(from: location)
        return favorites.contains(where: { $0.latitude == wrapper.latitude && $0.longitude == wrapper.longitude })
    }
    
    func hasFavorites() -> Bool {
        return !favorites.isEmpty
    }
}
