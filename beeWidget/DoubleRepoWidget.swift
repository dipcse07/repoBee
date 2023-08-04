//
//  repoWatcherWidget.swift
//  repoWatcherWidget
//
//  Created by MD SAZID HASAN DIP on 2023/02/27.
//


import WidgetKit
import SwiftUI

struct DoubleRepoProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> DoubleRepoEntry {
        DoubleRepoEntry(date: Date(),topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    
    func getSnapshot(for configuration: SelectTwoReposIntent, in context: Context, completion: @escaping (DoubleRepoEntry) -> Void) {
        let entry = DoubleRepoEntry(date: Date(),topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectTwoReposIntent, in context: Context, completion: @escaping (Timeline<DoubleRepoEntry>) -> Void) {
        Task {
            
            //var entries: [RepoEntry] = []
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            do { //MARK: - Get top repo
                var topRepo = try await NetworkManager.shared.getRepo(atUrl: RepoUrl.prefix + configuration.topRepo!)
                let topAvatarImageData = await NetworkManager.shared.downloadImageData(from: topRepo.owner.avatarUrl)
                topRepo.avatarData = topAvatarImageData ?? Data()
      
                
                //MARK: - Get Bottom Repo if in Large Widget
                
                var  bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoUrl.prefix + configuration.bottomRepo!)
                    let bottomAvatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo.owner.avatarUrl)
                    bottomRepo.avatarData = bottomAvatarImageData ?? Data()
            
                
                //MARK: - Create Entry and Timeline
                let entry = DoubleRepoEntry(date: .now, topRepo: topRepo, bottomRepo:  bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            }catch{
                print("❌ Error = \(error.localizedDescription)")
            }
            
           
        }
    }
    

}

struct DoubleRepoEntry: TimelineEntry {
    let date: Date
    let topRepo: Repository
    let bottomRepo: Repository
}

struct DoubleRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: DoubleRepoProvider.Entry
    
    

    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.topRepo)
      
        case .systemLarge:
            VStack (spacing:30){
                RepoMediumView(repo: entry.topRepo)
                RepoMediumView(repo: entry.bottomRepo)
            }
            
        case .systemExtraLarge:
            EmptyView()
            case .accessoryCircular, .systemSmall, .accessoryRectangular, .accessoryInline:
            
            EmptyView()
            
        
        @unknown default:
            EmptyView()
        }
        
    }
    
    
}

struct DoubleRepoWidget: Widget {
    let kind: String = "DoubleRepoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectTwoReposIntent.self, provider: DoubleRepoProvider()) { entry in
            DoubleRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Double repo Widget")
        .description("Track multiple repos")
        .supportedFamilies([ .systemLarge])
    }
}

struct DoubleRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        DoubleRepoEntryView(entry: DoubleRepoEntry(date: Date(),topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

