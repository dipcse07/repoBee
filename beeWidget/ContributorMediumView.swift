//
//  ContributorMediumView.swift
//  repoWatcherWidgetExtension
//
//  Created by MD SAZID HASAN DIP on 2023/03/14.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
    let repo: Repository
    var body: some View {
        VStack {
            HStack {
                Text("TopContributors")
                    .font(.caption).bold()
                    .foregroundColor(.secondary)
                Spacer()
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .leading,spacing: 20){
                ForEach(repo.contributors) { contributor in
                    HStack {
                        Image(uiImage: UIImage(data:contributor.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 44, height: 44 )
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading){
                            Text(contributor.login)
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                        }
                    }
                }
            }
            
        }
        .containerBackground(for: .widget) {
            Color.accentColor
        }
        .padding()
    }
}

struct ContributorMediumView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorMediumView(repo: MockData.repoOne)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
    }
}

//#Preview {
//    ContributorMediumView(repo: MockData.repoOne)
//}
