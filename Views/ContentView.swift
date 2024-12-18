//
//  ContentView.swift
//  WeatherTracker
//
//  Created by Wenbo Ma on 12/16/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // SearchBarView Always on top
            SearchBarView(viewModel: viewModel)
                .padding()
                .background(Color(.systemGray6)) // Add background color to highlight search bar
                .zIndex(1) // Ensure to be above the view hierarchy

            // Remaining content
            if let weather = viewModel.weather {
                ScrollView { // Support content scrolling
                    VStack(spacing: 16) {
                        // Weather Icon
                        AsyncImage(url: URL(string: weather.weatherIconURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView() // Loading state
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle()) // Optional styling
                            case .failure:
                                Image(systemName: "photo") // Fallback icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding(.bottom, 16)

                        // City Name
                        Text(weather.cityName)
                            .font(.title)

                        // Temperature
                        Text("\(Int(weather.temperature))°")
                            .font(.largeTitle)

                        // Additional Weather Info
                        HStack(spacing: 32) {
                            WeatherInfoView(label: "Humidity", value: "\(Int(weather.humidity))%")
                            WeatherInfoView(label: "UV Index", value: "\(Int(weather.uvIndex))")
                            WeatherInfoView(label: "Feels like", value: "\(Int(weather.feelsLike))°")
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                    .padding()
                }
            } else {
                ZStack {
                    Color(.systemBackground)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 8) {
                        Text("No City Selected")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Text("Please Search For A City")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.loadSavedCity()
        }
    }
}

// Reusable Weather Info View
struct WeatherInfoView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
        }
    }
}
