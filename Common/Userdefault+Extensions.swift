//
//  Userdefault+Extensions.swift
//  Calculator
//
//  Created by 서창열 on 2022/05/12.
//

import Foundation
extension UserDefaults {
    var lastAdWatchTime:Date? {
        set {
            set(newValue?.timeIntervalSince1970, forKey: "lastAdWatchTime")
        }
        get {
            let value = double(forKey: "lastAdWatchTime")
            if value > 0 {
                return Date(timeIntervalSince1970: double(forKey: "lastAdWatchTime"))
            } else {
                return nil
            }
        }
    }
    
    var favorites:[String] {
        set {            
            let str = Set(newValue).joined(separator: ",")
            set(str, forKey: "favorites")
            AppGroup.save(filename: "favorites", key: "favorites", value: newValue)
        }
        get {
            if let value = AppGroup.load(filename: "favorites", key: "favorites") as? [String] {
                return value
            }
            if let str = string(forKey: "favorites") {
                
                var list = str.components(separatedBy: ",")
                while list.last?.isEmpty == true {
                    list.removeLast()
                }
                return list
            }
            return []
        }
    }
    
    func isFavorites(name:String)->Bool {
        return favorites.filter { str in
            return str == name
        }.count > 0
    }
    
    func toggleFavorits(name:String) {
        if isFavorites(name: name) == false {
            favorites.append(name)
        } else {
            var list = favorites
            if let idx = list.firstIndex(of: name) {
                list.remove(at: idx)
                favorites = list
            }
        }
    }
    
    func saveOption(data:Option) {
        AppGroup.save(filename: "SFSymbolOption", key: "data", value: data.dicValue)
    }
    
    func loadOption()->Option {
        if let data = AppGroup.load(filename: "SFSymbolOption", key: "data") as? [String:Int] {
            return Option(dic: data)
        }
        return .init(renderingModeSelect: 0, fontWeightSelect: 0, forgroundColorSelect1: 0, forgroundColorSelect2: 0, forgroundColorSelect3: 0)
    }
}

