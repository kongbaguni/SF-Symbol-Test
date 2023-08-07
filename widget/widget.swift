//
//  widget.swift
//  widget
//
//  Created by Changyeol Seo on 2023/08/07.
//

import WidgetKit
import SwiftUI
import Intents
fileprivate var favoritesRendom4:[String] {
    var arr = UserDefaults.standard.favorites
    var result:[String] = []
    let limit = arr.count > 4 ? 4 : arr.count
    while result.count < limit {
        if let el = arr.randomElement(),
           let idx = arr.firstIndex(of: el) {
            result.append(el)
            arr.remove(at: idx)
        }
    }
    return result
}


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            favorites: favoritesRendom4,
            option: UserDefaults.standard.loadOption(),
            configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            favorites: favoritesRendom4,
            option: UserDefaults.standard.loadOption(),
            configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                favorites: favoritesRendom4,
                option: UserDefaults.standard.loadOption(),
                configuration: configuration
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let favorites: [String]
    let option : Option
    let configuration: ConfigurationIntent
}

struct widgetEntryView : View {
    var columns : [GridItem] = .init(repeating: .init(.flexible()), count: 2)
    var entry: Provider.Entry

    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(entry.favorites, id:\.self) { str in
                    Image(systemName: str)
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                        .fontWeight(entry.option.fontWeight.1)
                        .symbolRenderingMode(entry.option.renderingMode.1)
                        .foregroundStyle(
                            entry.option.forgroundColor1.1,
                            entry.option.forgroundColor2.1,
                            entry.option.forgroundColor3.1)
                }
            }
        }
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("SF Symbols Navigator")
        .description("SF Symbols Navigator's Widget ")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(
            date: Date(),
            favorites: ["circle","square.and.arrow.up","circle","circle"],
            option: .init(renderingModeSelect: 0, fontWeightSelect: 0, forgroundColorSelect1: 0, forgroundColorSelect2: 0, forgroundColorSelect3: 0),
            configuration: ConfigurationIntent()
        )
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
