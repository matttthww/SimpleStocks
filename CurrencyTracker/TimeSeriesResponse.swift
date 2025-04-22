//
//  TimeSeriesResponse.swift
//  CurrencyTracker
//
//  Created by mattthew on 4/12/25.
//

import Foundation

struct TimeSeriesResponse: Codable {
    let metaData: MetaData
    let timeSeries: [String: StockData]

    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (5min)"
    }
}

struct MetaData: Codable {
    let symbol: String

    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct StockData: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
