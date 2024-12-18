//
//  WeatherService.swift
//  WeatherTracker
//
//  Created by Kimberly Qian on 12/16/24.
//

import Foundation

struct WeatherService {
    let apiKey = "76bbdd6dca454755bd9220923241712"
    
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(city)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        //https://api.weatherapi.com/v1/current.json?key=76bbdd6dca454755bd9220923241712&q=San Jose
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL, noData
}
