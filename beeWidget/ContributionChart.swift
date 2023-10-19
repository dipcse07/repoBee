//
//  ContributionChart.swift
//  repoBee
//
//  Created by intel on 2023/10/18.
//

import SwiftUI
import WidgetKit
import InterfaceKit
struct ContributionChart: View {
    @State private var colors: [[Color]] = []

   
    
    var body: some View {
        VStack {
            if colors.isEmpty {
                Text("Loading...") // Display a loading message while fetching data.
            } else {
                ContributionsView(rowsCount: 7, columnsCount: 20, colors: colors)
            }
        }
        .containerBackground(.white, for: .widget)
        .padding()
        .onAppear {
            fetchColors()
        }
    }
    
    func fetchColors() {
        Task {
            do {
                let fetchedColors = try await NetworkManager.shared.getColorsFromCommitsAndDates(atUrl: RepoUrl.prefix + "google/xls" + "/commits")
                colors = fetchedColors
            } catch {
                print("Error: ", error.localizedDescription)
            }
        }
    }
}


//#Preview {
//    ContributionChart()
//        .previewContext(WidgetPreviewContext(family: .systemMedium))
//}


struct ContributionChart_Previews: PreviewProvider {
    static var previews: some View {
        ContributionChart()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
