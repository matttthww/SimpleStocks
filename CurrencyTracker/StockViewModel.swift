//
//  StockViewModel.swift
//  CurrencyTracker
//
//  Created by mattthew on 4/12/25.
//

import Foundation


struct StockPoint: Identifiable{
    let id = UUID()
    let time: Date
    let close: Double
}




class StockViewModel: ObservableObject{
    @Published var stockData: [String: StockData] = [:]
    @Published var symbol: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var stockPoints: [StockPoint]{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return stockData.compactMap { (timestamp, data) in
                guard let date = formatter.date(from: timestamp),
                      let close = Double(data.close) else { return nil }
                return StockPoint(time: date, close: close)
            }
            .sorted(by: { $0.time < $1.time })
    }
    
    
    func loadStockData() async {
        isLoading = true
        errorMessage = nil
        
        let request = IntradayRequest(symbol: symbol, interval: "5min", adjusted: true, extendedHours: true, month: nil, outputSize: "full", dataType: "json")
        
        do{
            let response = try await NetworkManager.fetchIntraday(for: request)
            stockData = response.timeSeries
            if stockData.isEmpty{
                errorMessage = "Invalid or out of API Calls"
            }else{
                print("loaded data")
            }
        }catch{
            errorMessage = "Error: \(error.localizedDescription)"
            print("❌ API Error: \(error)")
        }
        
        isLoading = false
        
    }
}


