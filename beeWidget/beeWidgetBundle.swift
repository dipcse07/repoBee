//
//  beeWidgetBundle.swift
//  beeWidget
//
//  Created by intel on 2023/08/04.
//

import WidgetKit
import SwiftUI

@main
struct beeWidgetBundle: WidgetBundle {
    var body: some Widget {
        SingleRepoWidget()
        
        DoubleRepoWidget()
    }
        
}
