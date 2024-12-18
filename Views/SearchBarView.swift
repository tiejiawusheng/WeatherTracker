//
//  SearchBarView.swift
//  WeatherTracker
//
//  Created by Kimberly Qian on 12/17/24.
//

import SwiftUI

struct SearchBarView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            TextField("Search location", text: $searchText, onCommit: {
                viewModel.searchCity(searchText)
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            if let searchResult = viewModel.searchResult {
                Button(action: {
                    viewModel.updateCity(searchResult)
                }) {
                    Text(searchResult.name)
                }
            }
        }
    }
}
