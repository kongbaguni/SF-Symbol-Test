//
//  SymbolNames.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/12.
//

import Foundation
let symbolNames:[String:[String]] = [
    "새로운 기호": [
        "backpack.circle",
        "backpack.circle.fill",
        "person.crop.circle.dashed",
        "figure.run.square.stack",
        "figure.run.square.stack.fill",
        "lane",
        "1.lane",
        "2.lane",
        "3.lane",
        "4.lane",
        "5.lane",
        "6.lane",
        "7.lane",
        "8.lane",
        "9.lane",
        "10.lane",
        "11.lane",
        "12.lane",
        "snowflake.slash",
        "play.square.stack",
        "play.square.stack.fill",
        "sos",
        "sos.circle",
        "sos.circle.fill",
        "flag.checkered.circle",
        "flag.checkered.circle.fill",
        "bolt.trianglebadge.exclamationmark",
        "bolt.trianglebadge.exclamationmark.fill",
        "handbag",
        "handbag.fill",
        "cross.case.circle",
        "cross.case.circle.fill",
        "suitcase.rolling",
        "suitcase.rolling.fill",
        "toilet.circle",
        "toilet.circle.fill",
        "tent.circle",
        "tent.circle.fill",
        "tent.2",
        "tent.2.fill",
        "tent.2.circle",
        "tent.2.circle.fill",
        "house.lodge",
        "house.lodge.fill",
        "house.lodge.circle",
        "house.lodge.circle.fill",
        "house.and.flag",
        "house.and.flag.fill",
        "house.and.flag.circle",
        "house.and.flag.circle.fill"
    ],
        
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

