//
//  DetailedWeatherView.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 23/01/2025.
//

import SwiftUI
import MapKit

struct DetailedWeatherView: View {
    let weatherData: DailyWeatherModel
    let isToday: Bool
    let hourlyForecast: [HourlyWeatherModel]
    let coordinates: CLLocationCoordinate2D
    
    @State private var region = MKCoordinateRegion()
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            backgroundColor(for: weatherData.weather.first?.main ?? "", mode: isDarkMode ? "dark" : "light")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                contentView
                hourlyForecastView
                if let lastUpdated = weatherViewModel.lastUpdated, !weatherViewModel.isDataFresh() {
                    Text("Offline Data - Last Updated: \(lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
        }
        .foregroundColor(.white)
    }
    
    private var contentView: some View {
        VStack(spacing: 20) {
            headerView
            weatherDetailsView
            mapView
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("\(Int(weatherData.temp.day))°")
                .font(.system(size: 60, weight: .bold))
            Text(weatherData.weather.first?.main ?? "N/A")
                .font(.title2)
            Text(isToday ? "Today" : convertDateToDay(weatherData.dt))
                .font(.subheadline)
        }
    }
    
    private var weatherDetailsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            detailRow(label: "Temperature", value: "\(Int(weatherData.temp.min))° / \(Int(weatherData.temp.max))°")
            detailRow(label: "Humidity", value: "\(weatherData.humidity)%")
            detailRow(label: "Pressure", value: "\(weatherData.pressure) hPa")
            detailRow(label: "Wind", value: "\(weatherData.wind_speed) m/s")
        }
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.body)
        }
    }
    
    private var hourlyForecastView: some View {
        VStack {
            Text("Hourly Forecast")
                .font(.title3).bold()
                .padding(.bottom, 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(hourlyForecast) { hourly in
                        VStack(spacing: 5) {
                            Text(hourly.time, style: .time)
                            Image(systemName: getWeatherIcon(for: hourly.weather.main ?? ""))
                                .foregroundColor(.white)
                            Text("\(Int(hourly.temperature))°")
                        }
                        .frame(width: 80, height: 120)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        .padding(.vertical, 5)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var mapView: some View {
        Map {
            Marker(coordinate: coordinates) {
                Label("Weather Location", systemImage: "mappin.and.ellipse")
                    .foregroundColor(.red)
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding(5)
                    .overlay(
                        Circle()
                            .stroke(Color.red, lineWidth: 2)
                    )
            }
        }
        .mapStyle(isDarkMode ? .hybrid(elevation: .realistic) : .standard)
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func convertDateToDay(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
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
            return mode == "dark" ? Color.black : Color.white
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
    
    private func setInitialRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        self.region = MKCoordinateRegion(center: coordinates, span: span)
    }
}

#Preview {
    let dummyHourlyData: [HourlyWeatherModel] = [
        HourlyData(dt: Int(Date().timeIntervalSince1970), main: HourlyData.Main(temp: 20), weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "sun.max.fill")], wind: HourlyData.Wind(speed: 5, deg: 200)),
        HourlyData(dt: Int(Date().timeIntervalSince1970) + 3600, main: HourlyData.Main(temp: 21), weather: [Weather(id: 801, main: "Clouds", description: "few clouds", icon: "cloud.fill")], wind: HourlyData.Wind(speed: 4, deg: 210)),
        HourlyData(dt: Int(Date().timeIntervalSince1970) + 7200, main: HourlyData.Main(temp: 19), weather: [Weather(id: 802, main: "Clouds", description: "scattered clouds", icon: "cloud.sun.fill")], wind: HourlyData.Wind(speed: 6, deg: 220)),
        HourlyData(dt: Int(Date().timeIntervalSince1970) + 10800, main: HourlyData.Main(temp: 20), weather: [Weather(id: 803, main: "Clouds", description: "broken clouds", icon: "cloud.fill")], wind: HourlyData.Wind(speed: 5, deg: 230))
    ].compactMap { HourlyWeatherModel(from: $0) }
    return DetailedWeatherView(weatherData: DailyWeatherModel(dt: Int(Date().timeIntervalSince1970), sunrise: 0, sunset: 0, temp: DailyTemp(day: 20, min: 15, max: 25, night: 18, eve: 22, morn: 16), feels_like: DailyFeelsLike(day: 20, night: 18, eve: 22, morn: 16), pressure: 1015, humidity: 60, dew_point: 15, wind_speed: 5, wind_deg: 200, wind_gust: 7, weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "sun.max.fill")], clouds: 0, pop: 0, uvi: 5), isToday: false, hourlyForecast: dummyHourlyData, coordinates: CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417))
        .environmentObject(WeatherViewModel())
}
