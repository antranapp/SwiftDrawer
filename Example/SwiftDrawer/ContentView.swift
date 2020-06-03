//
//  ContentView.swift
//  DrawerDemo
//
//  Created by Millman on 2019/6/25.
//  Copyright © 2019 Millman. All rights reserved.
//

import SwiftUI
import SwiftDrawer


import SwiftDrawer
import SwiftUI

class AppState: ObservableObject {
    @Published var sliderState: [SliderType: ShowStatus] = [.leftRear: .hide]
    @Published var isOn: Bool = false
    @Published var editMode: EditMode = .inactive
}

struct ContentView : View {

    @EnvironmentObject var appState: AppState
    
    var body: some View {
        return Drawer(sliderState: self.$appState.sliderState)
            .setSlider(view: SliderView(type: .leftRear, appState: appState), initialShowStatus: self.appState.sliderState[.leftRear] ?? .hide)
            .setMain(view: HomeView2().environmentObject(appState), configuration: Configuration(dragGestureEnabled: self.appState.editMode == .inactive))
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
