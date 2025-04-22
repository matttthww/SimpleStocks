//
//  WaitlistView.swift
//  CurrencyTracker
//
//  Created by mattthew on 4/12/25.
//

import SwiftUI

struct SymbolRow: View {
    let symbol:String
    let price:String?
    var body: some View{
        HStack{
            Text(symbol).bold()
            Spacer()
            Text(price ?? "--")
        }
    }
}


struct WaitlistView: View {
    @Binding var trackedSymbols: [String]
    @State private var priceSummaries: [String: String] = [:]
    
    var body: some View {
        
        VStack{
            Text("Your Tracked Stocks")
                .font(.title)
                .padding(10)
            List{
                ForEach(trackedSymbols, id: \.self){symbol in
                    
                    SymbolRow(symbol: symbol, price: priceSummaries[symbol])
                        .task { if priceSummaries[symbol] == nil {await loadSummary(for: symbol)}}
                }
            }
        }
        
    }
    
    
    func loadSummary(for symbol: String) async{
        let request = IntradayRequest(symbol: symbol, interval: "5min", adjusted: true, extendedHours: true, month: nil, outputSize: "compact", dataType: "json")
        
        do{
            let response = try await NetworkManager.fetchIntraday(for: request)
            if let latest = response.timeSeries.sorted(by: { $0.key > $1.key }).first {
                await MainActor.run {
                    priceSummaries[symbol] = latest.value.close
                }
            }
        } catch {
            await MainActor.run {
                priceSummaries[symbol] = "Err"
            }
            
        }}
}
    
    

