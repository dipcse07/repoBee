//
//  ContributorWidget.swift
//  repoWatcherWidgetExtension
//
//  Created by MD SAZID HASAN DIP on 2023/03/13.
//

import Foundation
import SwiftUI
import WidgetKit
struct SingleReopProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }

    
    func getSnapshot(for configuration: SelectSingleRepoIntent, in context: Context, completion: @escaping (SingleRepoEntry) -> Void) {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectSingleRepoIntent, in context: Context, completion: @escaping (Timeline<SingleRepoEntry>) -> Void) {
        let nextUpdate = Date().addingTimeInterval(43200)
        Task {
            do {
                
                let repoToShow = RepoUrl.prefix + configuration.repo!
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                if context.family == .systemLarge {
                    let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                    
                    var topFour = Array(contributors.prefix(4))
                    
                    //MARK: - Download Top Four contributors avatar image
                    for i in topFour.indices {
                        let contributorImgData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                        topFour[i].avatarData = contributorImgData ?? Data()
                    }
                    repo.contributors = topFour
                    
                    //MARK: Download Commits By Dates
                
                }
                let commits = try await NetworkManager.shared.getCommitsAndDates(atUrl: RepoUrl.googleSignIn + "/commits")
                print(commits)
                
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


struct SingleRepoEntryView : View {
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
            
        case .accessoryInline:
            Text("\(entry.repo.name) - \(entry.repo.daysSinceLastActivity)days")
            
        case .accessoryCircular:
            
            ZStack {
                AccessoryWidgetBackground()
                VStack{
                    Text("\(entry.repo.daysSinceLastActivity)")
                    Text("Days")
                }
            }
            
            
        case .accessoryRectangular:
            VStack(alignment: .leading){
                Text(entry.repo.name)
                    .font(.headline)
                Text("\(entry.repo.daysSinceLastActivity) days")
                
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    Text("\(entry.repo.watchers)")
                    Image(systemName: "tuningfork")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    Text("\(entry.repo.forks)")
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    Text("\(entry.repo.openIssues)")
                }
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
        IntentConfiguration(kind: kind, intent: SelectSingleRepoIntent.self, provider: SingleReopProvider()) { entry in
            SingleRepoEntryView(entry: entry)
        }

        .configurationDisplayName("Single Repo Widget")
        .description("This is an example widget.")
        .supportedFamilies([ .systemLarge, .systemMedium, .accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}


struct SingleRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        SingleRepoEntryView(entry: SingleRepoEntry(date: Date(), repo: MockData.repoOne))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


