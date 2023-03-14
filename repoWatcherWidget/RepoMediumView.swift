//
//  RepoMediumView.swift
//  repoWatcher
//
//  Created by MD SAZID HASAN DIP on 2023/03/08.
//

import SwiftUI
import WidgetKit

struct RepoMediumView: View {
    let repo: Repository
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int {
       return calculateDateSinceLastActivity(from: repo.pushedAt)
    }
    

    var body: some View {
        HStack {
            VStack (alignment: .leading){
                HStack {
                    Image(uiImage: UIImage(data: repo.avatarData ) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    Text(repo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6 )
                HStack {
                    StatLabel(value: repo.watchers, sysImageName: "star.fill")
                    StatLabel(value: repo.forks, sysImageName: "tuningfork")
                    if repo.hasIssues {
                        StatLabel(value: repo.openIssues, sysImageName: "exclamationmark.triangle.fill")
                    }
                }
            }
            Spacer()
            VStack {
                Text("\(daysSinceLastActivity)")
                    .font(.system(size: 70))
                    .frame(width:90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .bold()
                    .foregroundColor(daysSinceLastActivity > 50 ?  .pink: .green)
                Text("days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    func calculateDateSinceLastActivity(from dateString: String) -> Int {
        
        let lastActivityDate = formatter.date(from:  dateString ) ?? .now
        let daySinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
        return daySinceLastActivity
    }
}

struct RepoMediumView_Previews: PreviewProvider {
    static var previews: some View {
        RepoMediumView(repo: MockData.repoOne)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

fileprivate struct StatLabel: View {
    var value:Int
    var sysImageName:String
    var body: some View{
        Label {
            Text ("\(value)")
                .font(.footnote)
            
        
        } icon: {
            Image(systemName: sysImageName)
                .foregroundColor(.green)
        }
        .fontWeight(.medium)
    }
}
