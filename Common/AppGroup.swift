//
//  AppGroup.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/05.
//

import Foundation
import SwiftUI
import WidgetKit

fileprivate let appGroupId = "group.net.kongbaguni"
struct AppGroup {
    fileprivate static func makedFileURL(fileName:String)->URL? {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        return sharedContainer?.appendingPathComponent(fileName)
    }
    
    fileprivate static func save(dic:[String:Any], url:URL) {
        do {
            let data = try JSONSerialization.data(withJSONObject: dic,options: [])
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func save(filename:String,key:String, value:Any) {
        var data:[String:Any] = [:]
        data[key] = value
        save(dic: data, url: makedFileURL(fileName: filename)!)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    fileprivate static func load(fileUrl:URL)->[String:Any]? {
        do {
            let data = try Data(contentsOf: fileUrl)
            let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            return dic
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func load(filename:String, key:String)->Any? {
        if let fileUrl = makedFileURL(fileName: filename),
           let data = load(fileUrl: fileUrl),
           let d = data[key] {
            return d
        }
        return nil
    }
        
}
