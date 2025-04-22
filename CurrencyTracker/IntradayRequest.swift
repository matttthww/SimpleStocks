//
//  IntradayRequest.swift
//  CurrencyTracker
//
//  Created by mattthew on 4/12/25.
//

import Foundation

struct IntradayRequest{
    let symbol: String
    let interval: String
    let adjusted: Bool?
    let extendedHours: Bool?
    let month: String?
    let outputSize: String?
    let dataType: String?
}

