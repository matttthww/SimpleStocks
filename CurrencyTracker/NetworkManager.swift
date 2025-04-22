//
//  NetworkManager.swift
//  CurrencyTracker
//
//  Created by mattthew on 4/21/25.
//

import Foundation

enum NetworkManager{
    private static func buildIntradayURL(request: IntradayRequest) -> URL? {
        var components = URLComponents(string:"https://www.alphavantage.co/query")
        let apiKey = "L8BX94QRDE7XZ28I"
        var queryItems = [
            URLQueryItem(name: "function", value: "TIME_SERIES_INTRADAY"),
            URLQueryItem(name: "symbol", value: request.symbol),
            URLQueryItem(name: "interval", value: request.interval),
            URLQueryItem(name: "apikey", value: apiKey),
        ]
        if let adjusted = request.adjusted {
            queryItems.append(URLQueryItem(name: "adjusted", value: adjusted ? "true" : "false"))
        }
        if let extendedHours = request.extendedHours {
            queryItems.append(URLQueryItem(name: "extended_hours", value: extendedHours ? "true" : "false"))
        }
        if let month = request.month {
            queryItems.append(URLQueryItem(name:"month",value:month))
        }
        if let outputSize = request.outputSize {
                queryItems.append(URLQueryItem(name: "outputsize", value: outputSize))
            }

        if let dataType = request.dataType {
                queryItems.append(URLQueryItem(name: "datatype", value: dataType))
            }

        components?.queryItems = queryItems
        return components?.url
    }
    
    
    static func fetchIntraday(for request: IntradayRequest) async throws -> TimeSeriesResponse{
        guard let url = buildIntradayURL(request: request) else{fatalError("Invalid URL")}
        let (data,_) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TimeSeriesResponse.self, from: data)
        return response
        
    }
    
}
