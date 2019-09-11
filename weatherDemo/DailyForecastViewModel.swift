//
//  DailyForecastViewModel.swift
//  weatherDemo
//
//  Created by Thidar Phyo on 9/8/19.
//  Copyright © 2019 Thidar Phyo. All rights reserved.
//

import UIKit

struct DailyForecastViewModel {
    let dayOfWeek : String
    
    static func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
extension DailyForecastViewModel {
    init?(dailyForecast: WeatherDataModel) {
        let date = Date(timeIntervalSince1970: TimeInterval(dailyForecast.time ?? 0))
        dayOfWeek = DailyForecastViewModel.format(date)
        
    }
}
