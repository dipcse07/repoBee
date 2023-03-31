//
//  ContributorWidget.swift
//  repoWatcherWidgetExtension
//
//  Created by MD SAZID HASAN DIP on 2023/03/13.
//

import Foundation
import SwiftUI
import WidgetKit
struct SingleReopProvider: TimelineProvider {
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SingleRepoEntry) -> Void) {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SingleRepoEntry>) -> Void) {
        let nextUpdate = Date().addingTimeInterval(43200)
        Task {
            do {
                let repoToShow = RepoUrl.swiftNews
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                
                var topFour = Array(contributors.prefix(4))
                
                //MARK: - Download Top Four contributors avatar image
                for i in topFour.indices {
                    let contributorImgData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = contributorImgData ?? Data()
                }
                repo.contributors = topFour
                
                let entry = SingleRepoEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline  )
            }catch {
                print("❌ Error = \(error.localizedDescription)")
            }

        }

    }

}

struct SingleRepoEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}


struct ContributorRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry
    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack {
                RepoMediumView(repo: entry.repo)
                ContributorMediumView(repo: entry.repo)
            }
        default:
            EmptyView()
        }
        
        //        Text(entry.date.formatted())
        
    }
    
}

struct SingleRepoWidget: Widget {
    let kind: String = "SingleRepoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleReopProvider()) { entry in
            ContributorRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Single Repo Widget")
        .description("This is an example widget.")
        .supportedFamilies([ .systemLarge, .systemMedium])
    }
}


struct SingleRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        ContributorRepoEntryView(entry: SingleRepoEntry(date: Date(), repo: MockData.repoOne))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
