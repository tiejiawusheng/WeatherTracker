//
//  Weather.swift
//  WeatherTracker
//
//  Created by Wenbo Ma on 12/16/24.
//

import Foundation

struct Weather: Decodable {
    let cityName: String
    let temperature: Double
    let condition: String
    let weatherIconURL: String
    let humidity: Int
    let uvIndex: Double
    let feelsLike: Double
    
    enum RootKeys: String, CodingKey {
        case location
        case current
    }
    
    enum LocationKeys: String, CodingKey {
        case name
    }
    
    enum CurrentKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case humidity
        case uv
        case feelsLikeC = "feelslike_c"
    }
    
    enum ConditionKeys: String, CodingKey {
        case text
        case icon
    }
    
    init(from decoder: Decoder) throws {
        // root level container
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // parse `location.name`
        let locationContainer = try rootContainer.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        cityName = try locationContainer.decode(String.self, forKey: .name)
        
        // parse `current`
        let currentContainer = try rootContainer.nestedContainer(keyedBy: CurrentKeys.self, forKey: .current)
        temperature = try currentContainer.decode(Double.self, forKey: .tempC)
        humidity = try currentContainer.decode(Int.self, forKey: .humidity)
        uvIndex = try currentContainer.decode(Double.self, forKey: .uv)
        feelsLike = try currentContainer.decode(Double.self, forKey: .feelsLikeC)
        
        // parse `current.condition.text` and `current.condition.icon`
        let conditionContainer = try currentContainer.nestedContainer(keyedBy: ConditionKeys.self, forKey: .condition)
        condition = try conditionContainer.decode(String.self, forKey: .text)
        let iconURL = try conditionContainer.decode(String.self, forKey: .icon)
        weatherIconURL = "https:" + iconURL
    }
}

struct City: Identifiable {
    let id = UUID()
    let name: String
}
