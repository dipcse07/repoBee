
import Foundation
import NetworkKit

struct GitHubContributionsViewModel {
    private let contributions: [String: Int]
    private let configuration: SelectSingleRepoIntent
    var theme: Theme {
        configuration.theme
    }

//    var isPureBlackEnabled: Bool {
//        configuration.pureBlack?.boolValue ?? false
//    }


 



//    var lastContributionDate: Date? {
//        contributions.last?.date
//    }

    func contributionLevels(rowsCount: Int, columnsCount: Int) -> [[Int]] {
//        guard let lastDate = lastContributionDate else { return [] }
//        let tilesCount = rowsCount * columnsCount - (rowsCount - Calendar.current.component(.weekday, from: lastDate))
//        return contributions.suffix(tilesCount).map(\.level).chunked(into: rowsCount)
        
       // let values =  contributions.values.map { [theme.color(for: GitHub.Contribution.Level(rawValue: $0) ?? .zero])
            
     //   }
        //print(values)
        return [[3]]
    }

    init(contributions: [String: Int], configuration: SelectSingleRepoIntent) {
        self.contributions = contributions
        self.configuration = configuration
    }
}
