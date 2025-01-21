//
//  MockNetworkManager.swift
//  WeatherAppSwiftUITests
//
//  Created by Kevin on 20/01/2025.
//

import Combine
import CoreLocation
import XCTest

@testable import WeatherAppSwiftUI


class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = WeatherViewModel()
        // viewModel.networkManager = mockNetworkManager
    }

    func testFetchWeatherSuccess() {
        let expectation = self.expectation(description: "Fetch weather successfully")
        
//        let mockWeather = WeatherModel(main: Main(temp: 20.0), weather: [Weather(description: "clear sky", id: 800)])
        let mockWeather = WeatherModel(main: "")
        mockNetworkManager.mockResponse = .success(mockWeather)
        
        viewModel.fetchWeather(for: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.viewModel.currentWeather)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

class MockNetworkManager: NetworkManager {
    var mockResponse: Result<Any, Error>?
    
    override func fetch<T>(_ type: T.Type, from urlString: String) -> AnyPublisher<T, Error> where T : Decodable {
        guard let result = mockResponse else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        switch result {
        case .success(let value):
            return Just(value as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
