//
//  HomeViewModel.swift
//  WeatherTracker
//
//  Created by Wenbo Ma on 12/16/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var searchResult: City?
    private let weatherService = WeatherService()
    private let userDefaultsKey = "SavedCity"
    
    func loadSavedCity() {
        if let savedCity = UserDefaults.standard.string(forKey: userDefaultsKey) {
            fetchWeather(for: savedCity)
        }
    }
    
    func searchCity(_ query: String) {
        weatherService.fetchWeather(for: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.searchResult = City(name: weather.cityName)
                case .failure(let error):
                    print("Error fetching city: \(error)")
                }
            }
        }
    }
    
    func updateCity(_ city: City) {
        UserDefaults.standard.set(city.name, forKey: userDefaultsKey)
        fetchWeather(for: city.name)
    }
    
    private func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.weather = weather
                case .failure(let error):
                    print("Error fetching weather: \(error)")
                }
            }
        }
    }
}
