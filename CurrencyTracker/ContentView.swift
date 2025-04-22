import SwiftUI
import Charts
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel = StockViewModel()
    @State private var trackedSymbols: [String] = []
    @State private var showWaitlistView = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Simple Stocks")
                    .font(.largeTitle)
                    .padding()
                
                
                    .toolbar{
                        ToolbarItem(placement: .navigation){
                            Button(action:{showWaitlistView = true}){
                                Image(systemName: "list.clipboard")
                            }
                        }
                    }
                    .padding()
                
                    .sheet(isPresented: $showWaitlistView){
                        WaitlistView(trackedSymbols: $trackedSymbols)
                    }
                

                HStack {
                    Text("Track a stock:")
                    TextField("Enter stock symbol", text: $viewModel.symbol)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)

                Button("See Stock") {
                    Task {
                        await viewModel.loadStockData()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)

                Button("Add to tracking") {
                    let symbol = viewModel.symbol.uppercased().trimmingCharacters(in: .whitespaces)
                    guard !symbol.isEmpty, !trackedSymbols.contains(symbol) else { return }
                    trackedSymbols.append(symbol)
                }

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    if let error = viewModel.errorMessage{
                        Text(error)
                    }
                    
                    if !viewModel.stockPoints.isEmpty {
                        Chart(viewModel.stockPoints) { point in
                            LineMark(
                                x: .value("Time", point.time),
                                y: .value("Close", point.close)
                            )
                            .foregroundStyle(.blue)
                            .interpolationMethod(.catmullRom)
                        }
                        .frame(height: 250)
                        .padding()
                    }

                    List(viewModel.stockData.sorted(by: { $0.key > $1.key }), id: \.key) { (timestamp, data) in
                        VStack(alignment: .leading) {
                            Text("Time: \(timestamp)").bold()
                            Text("Open: \(data.open)")
                            Text("Close: \(data.close)")
                            Text("High: \(data.high)")
                            Text("Low: \(data.low)")
                            Text("Volume: \(data.volume)")
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        
    }
}

@Model
class trackedSymbols{
    var symbols: [String] = []
    
    init(symbols: [String]) {
        self.symbols = symbols
    }
}

#Preview {
    ContentView()
}

