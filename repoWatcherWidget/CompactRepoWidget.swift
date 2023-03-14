//
//  repoWatcherWidget.swift
//  repoWatcherWidget
//
//  Created by MD SAZID HASAN DIP on 2023/02/27.
//

import WidgetKit
import SwiftUI

struct CompactRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompactRepoEntry {
        CompactRepoEntry(date: Date(),repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
        let entry = CompactRepoEntry(date: Date(),repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task {
            
            //var entries: [RepoEntry] = []
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            do { //MARK: - Get top repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoUrl.swiftNews)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                //MARK: - Get Bottom Repo if in Large Widget
                var bottomRepo:Repository?
                if context.family == .systemLarge {
                    bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoUrl.googleSignIn)
                    let avatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo!.owner.avatarUrl)
                    bottomRepo!.avatarData = avatarImageData ?? Data()
                }
                
                //MARK: - Create Entry and Timeline
                let entry = CompactRepoEntry(date: .now, repo: repo, bottomRepo:  bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            }catch{
                print("❌ Error = \(error.localizedDescription)")
            }
            
           
        }
    }
}

struct CompactRepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let bottomRepo: Repository?
}

struct CompactRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CompactRepoProvider.Entry
    
    

    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
      
        case .systemLarge:
            VStack (spacing:30){
                RepoMediumView(repo: entry.repo)
                RepoMediumView(repo: entry.bottomRepo!)
            }
            
        case .systemExtraLarge,.accessoryCircular, .systemSmall, .accessoryRectangular, .accessoryInline:
            
            EmptyView()
            
        
        @unknown default:
            EmptyView()
        }
        
    }
    
    
}

struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CompactRepoProvider()) { entry in
            CompactRepoEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([ .systemLarge])
    }
}

struct CompactRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CompactRepoEntryView(entry: CompactRepoEntry(date: Date(),repo: MockData.repoOne, bottomRepo: MockData.repoTwo ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

