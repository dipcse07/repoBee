//
//  repoWatcherWidget.swift
//  repoWatcherWidget
//
//  Created by MD SAZID HASAN DIP on 2023/02/27.
//

import WidgetKit
import SwiftUI

struct DoubleRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> DoubleRepoEntry {
        DoubleRepoEntry(date: Date(),topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DoubleRepoEntry) -> ()) {
        let entry = DoubleRepoEntry(date: Date(),topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task {
            
            //var entries: [RepoEntry] = []
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do { //MARK: - Get top repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoUrl.swiftNews)
                let topAvatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = topAvatarImageData ?? Data()
                
                
                //MARK: - Get Bottom Repo if in Large Widget
                
                
                var  bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoUrl.googleSignIn)
                let bottomAvatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo.owner.avatarUrl)
                bottomRepo.avatarData = bottomAvatarImageData ?? Data()
                
                
                //MARK: - Create Entry and Timeline
                let entry = DoubleRepoEntry(date: .now, topRepo: repo, bottomRepo:  bottomRepo)
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
            
        case .systemLarge:
            VStack (spacing:30){
                RepoMediumView(repo: entry.topRepo)
                RepoMediumView(repo: entry.bottomRepo)
            }
            
        case .systemExtraLarge, .accessoryCircular, .systemSmall, .accessoryRectangular, .accessoryInline,.systemMedium:
            
            EmptyView()
            
            
        @unknown default:
            EmptyView()
        }
        
    }
    
    
}

struct DoubleRepoWidget: Widget {
    let kind: String = "DoubleRepoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DoubleRepoProvider()) { entry in
            DoubleRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Double repo Widget")
        .description("Tack a Double repo")
        .supportedFamilies([.systemExtraLarge])
    }
}

struct DoubleRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        DoubleRepoEntryView(entry: DoubleRepoEntry(date: Date(),topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

