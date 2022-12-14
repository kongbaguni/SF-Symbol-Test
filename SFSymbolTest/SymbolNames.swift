//
//  SymbolNames.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/12.
//

import Foundation
let symbolNames:[String:[String]] = [
    "날씨" : [
        "aqi.high",
        "aqi.low",
        "aqi.medium",
        "carbon.dioxide.cloud",
        "carbon.dioxide.cloud.fill",
        "carbon.monoxide.cloud",
        "carbon.monoxide.cloud.fill",
        "cloud",
        "cloud.bolt",
        "cloud.bolt.circle",
        "cloud.bolt.circle.fill",
        "sun.min",
        "sun.min.fill",
        "sun.max",
        "sun.max.fill",
        "sun.max.circle",
        "sun.max.circle.fill",
        "sun.max.trianglebadge.exclamationmark",
        "sun.max.trianglebadge.exclamationmark.fill"
    ],
    "통신" : [
        "mic",
        "mic.fill",
        "mic.circle"
    ]
]

var symbolKeys : [String] {
    symbolNames.map { (key: String, value: [String]) in
        return key
    }.sorted()
}

