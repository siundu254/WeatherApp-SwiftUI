//
//  NetworkManager.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 20/01/2025.
//

import Combine
import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

class NetworkManager {
    func fetch<T: Decodable>(_ type: T.Type, from urlString: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return APIError.decodingError
                } else {
                    return APIError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
}
