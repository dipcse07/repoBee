//
//  ContributorWidget.swift
//  repoWatcherWidgetExtension
//
//  Created by MD SAZID HASAN DIP on 2023/03/13.
//

import Foundation
import SwiftUI
import WidgetKit
struct ContributorProvider: TimelineProvider {
    func placeholder(in context: Context) -> ContributorEntry {
        ContributorEntry(date: .now, repo: MockData.repoOne)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {
        let nextUpdate = Date().addingTimeInterval(43200)
        let entry = ContributorEntry(date: .now, repo: MockData.repoTwo)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline  )
    }
    
    
    
    
}

struct ContributorEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}


struct ContributorRepoEntryView : View {
    
    var entry: ContributorEntry
    var body: some View {
        VStack {
            RepoMediumView(repo: entry.repo)
            ContributorMediumView(repo: entry.repo)
        }
        //        Text(entry.date.formatted())
        
    }
    
}

struct ContributorWidget: Widget {
    let kind: String = "ContributorWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributorProvider()) { entry in
            ContributorRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Contributor Widget")
        .description("This is an example widget.")
        .supportedFamilies([ .systemLarge])
    }
}


struct ContributorWidget_Previews: PreviewProvider {
    static var previews: some View {
        ContributorRepoEntryView(entry: ContributorEntry(date: Date(), repo: MockData.repoOne))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
