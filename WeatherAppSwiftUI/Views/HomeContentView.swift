//
//  HomeContentView.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 22/01/2025.
//

import SwiftUI
import CoreLocation

struct HomeContentView: View {
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    @State private var isLoading = true
    @State private var isOffline = false
    @State private var showFavorites = false
    @State private var selectedWeather: SelectedWeather?
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ProgressView("Loading Weather Data...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let userLocation = locationViewModel.userLocation,
                      let currentWeather = weatherViewModel.currentWeather,
                      let forecast = weatherViewModel.forecast {
                VStack(spacing: 0) {
                    headerView(currentWeather: currentWeather, userLocation: userLocation)
                    temperatureSummaryView(currentWeather: currentWeather)
                    Rectangle().fill(Color.white).frame(height: 1)
                    forecastListView(forecast: forecast, userLocation: userLocation)
                }
                if isOffline {
                    Text("Offline Mode - Last Updated: \(weatherViewModel.lastUpdated?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown")")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                }
            } else {
                Text("Getting your location...")
                    .padding()
            }
        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: locationViewModel.userLocation) { newLocation in
            if let userLocation = newLocation {
                weatherViewModel.fetchWeather(for: userLocation.coordinate) {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.isOffline = !self.weatherViewModel.isDataFresh()
                    }
                }
            }
        }
        .sheet(item: $selectedWeather) { item in
            DetailedWeatherView(weatherData: item.weatherModel, isToday: item.isToday, hourlyForecast: item.hourlyForecast, coordinates: item.coordinates)
                .environmentObject(weatherViewModel)
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesListView()
                .environmentObject(weatherViewModel)
        }
        .onAppear {
            self.isOffline = !weatherViewModel.isDataFresh()
        }
    }
    
    private func headerView(currentWeather: CurrentWeatherModel, userLocation: CLLocation) -> some View {
        ZStack(alignment: .top) {
            Image(uiImage: UIImage(named: imageName(for: currentWeather.weather.first?.main ?? "", mode: isDarkMode ? "dark" : "light")) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .edgesIgnoringSafeArea(.top)
            
            HStack {
                Spacer()
                Menu {
                    Button(action: { isDarkMode.toggle() }) {
                        Text(isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode")
                    }
                    if weatherViewModel.isLocationFavorited(userLocation) {
                        Button(action: {
                            weatherViewModel.removeFromFavorites(userLocation)
                        }) {
                            Text("Remove from Favorites")
                        }
                        Button(action: {
                            showFavorites = true
                        }) {
                            Text("List Favorites")
                        }
                    } else {
                        Button(action: {
                            weatherViewModel.addToFavorites(userLocation)
                        }) {
                            Text("Add to Favorites")
                        }
                        if weatherViewModel.hasFavorites() {
                            Button(action: {
                                showFavorites = true
                            }) {
                                Text("List Favorites")
                            }
                        }
                    }
                } label: {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .padding()
                }
            }
            .padding(.horizontal)
            .padding(.trailing, -20)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("\(Int(currentWeather.temp))°")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                
                Text(currentWeather.weather.first?.main.uppercased() ?? "N/A")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.leading, 10)
            }
            .padding(.top, 100)
            .onTapGesture {
                if let currentWeather = weatherViewModel.currentWeather {
                    self.showDetailView(for: currentWeather, isToday: true, hourlyForecast: weatherViewModel.hourlyForecast, coordinates: userLocation.coordinate)
                }
            }
        }
        .frame(height: 300)
        .padding(.bottom, 10)
    }
    
    private func temperatureSummaryView(currentWeather: CurrentWeatherModel) -> some View {
        HStack(spacing: 0) {
            VStack(spacing: 10) {
                Text("\(Int(currentWeather.temp))°")
                    .foregroundColor(.white)
                    .font(.title2)
                Text("Current")
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(.top, -5)
            }
            .padding(.leading, 20)
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("\(Int(currentWeather.feels_like))°")
                    .foregroundColor(.white)
                    .font(.title2)
                Text("Feels Like")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.top, -5)
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("\(Int(currentWeather.temp))°")
                    .foregroundColor(.white)
                    .font(.title2)
                Text("Current")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.top, -5)
            }
            .padding(.trailing, 20)
        }
        .padding(.vertical, 10)
        .background(backgroundColor(for: currentWeather.weather.first?.main ?? "", mode: isDarkMode ? "dark" : "light"))
    }
    
    private func forecastListView(forecast: ForecastListModel, userLocation: CLLocation) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(forecast.list.prefix(5), id: \.dt) { forecastItem in
                    HStack {
                        Text(convertDateToDay(forecastItem.dt))
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: getWeatherIcon(for: forecastItem.weather.first?.main ?? ""))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(forecastItem.temp.day))°")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(height: 60)
                    .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .background(backgroundColor(for: forecastItem.weather.first?.main ?? "", mode: isDarkMode ? "dark" : "light"))
                    .onTapGesture {
                        self.showDetailView(for: forecastItem, isToday: false, hourlyForecast: weatherViewModel.hourlyForecast, coordinates: userLocation.coordinate)
                    }
                }
            }
        }
        .background(backgroundColor(for: weatherViewModel.currentWeather?.weather.first?.main ?? "", mode: isDarkMode ? "dark" : "light"))
    }
    
    private func showDetailView(for weatherModel: Any, isToday: Bool, hourlyForecast: [HourlyWeatherModel], coordinates: CLLocationCoordinate2D) {
        if let dailyWeather = weatherModel as? DailyWeatherModel {
            selectedWeather = SelectedWeather(weatherModel: dailyWeather, isToday: isToday, hourlyForecast: hourlyForecast, coordinates: coordinates)
        } else if let currentWeather = weatherModel as? CurrentWeatherModel {
            let convertedWeather = DailyWeatherModel(
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
            selectedWeather = SelectedWeather(weatherModel: convertedWeather, isToday: isToday, hourlyForecast: hourlyForecast, coordinates: coordinates)
        }
    }
    
    private func imageName(for condition: String, mode: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return mode == "dark" ? "forest_sunny" : "sea_sunny"
        case "clouds":
            return mode == "dark" ? "forest_cloudy" : "sea_cloudy"
        case "rain":
            return mode == "dark" ? "forest_rainy" : "sea_rainy"
        default:
            return ""
        }
    }
    
    private func backgroundColor(for condition: String, mode: String) -> Color {
        switch condition.lowercased() {
        case "clear":
            return mode == "dark" ? Color(hex: "#47AB2F") : Color(hex: "#4E92E2")
        case "rain":
            return mode == "dark" ? Color(hex: "#57575d") : Color(hex: "#707074")
        case "clouds":
            return mode == "dark" ? Color(hex: "#628594") : Color(hex: "#54717A")
        default:
            return Color.white
        }
    }
    
    private func getWeatherIcon(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return "sun.max.fill"
        case "clouds":
            return "cloud.fill"
        case "rain":
            return "cloud.rain.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    private func convertDateToDay(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
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
    HomeContentView()
}
