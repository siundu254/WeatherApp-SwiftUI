//
//  FavoritesListView.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 25/01/2025.
//

import SwiftUI
import CoreLocation

struct FavoritesListView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var selectedWeather: SelectedWeather?
    
    var body: some View {
        NavigationView {
            List(weatherViewModel.favorites, id: \.self) { favorite in
                VStack(alignment: .leading, spacing: 5) {
                    Text("Latitude: \(favorite.latitude, specifier: "%.4f")")
                    Text("Longitude: \(favorite.longitude, specifier: "%.4f")")
                }
                .onTapGesture {
                    let coordinates = CLLocationCoordinate2D(latitude: favorite.latitude, longitude: favorite.longitude)
                    weatherViewModel.fetchWeather(for: coordinates) {
                        DispatchQueue.main.async {
                            if let currentWeather = self.weatherViewModel.currentWeather,
                               let forecast = self.weatherViewModel.forecast {
                                let dailyWeather = DailyWeatherModel(
                                    dt: currentWeather.dt,
                                    sunrise: currentWeather.sunrise,
                                    sunset: currentWeather.sunset,
                                    temp: DailyTemp(
                                        day: currentWeather.temp,
                                        min: currentWeather.temp,
                                        max: currentWeather.temp,
                                        night: currentWeather.temp,
                                        eve: currentWeather.temp,
                                        morn: currentWeather.temp
                                    ),
                                    feels_like: DailyFeelsLike(
                                        day: currentWeather.feels_like,
                                        night: currentWeather.feels_like,
                                        eve: currentWeather.feels_like,
                                        morn: currentWeather.feels_like
                                    ),
                                    pressure: currentWeather.pressure,
                                    humidity: currentWeather.humidity,
                                    dew_point: currentWeather.dew_point,
                                    wind_speed: currentWeather.wind_speed,
                                    wind_deg: currentWeather.wind_deg,
                                    wind_gust: 0.0,
                                    weather: currentWeather.weather,
                                    clouds: currentWeather.clouds,
                                    pop: 0.0,
                                    uvi: currentWeather.uvi
                                )
                                self.selectedWeather = SelectedWeather(
                                    weatherModel: dailyWeather,
                                    isToday: false,
                                    hourlyForecast: self.weatherViewModel.hourlyForecast,
                                    coordinates: coordinates
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .sheet(item: $selectedWeather) { weather in
            DetailedWeatherView(weatherData: weather.weatherModel, isToday: weather.isToday, hourlyForecast: weather.hourlyForecast, coordinates: weather.coordinates)
                .environmentObject(weatherViewModel)
        }
    }
    
    struct SelectedWeather: Identifiable {
        let id = UUID()
        var weatherModel: DailyWeatherModel
        let isToday: Bool
        let hourlyForecast: [HourlyWeatherModel]
        let coordinates: CLLocationCoordinate2D
    }
}

#Preview {
    FavoritesListView()
        .environmentObject(WeatherViewModel())
}
