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
    @Published var sliderState: [SliderType: ShowStatus] = [.leftRear: .hide, .rightFront: .hide]
    
    @Published var isOn: Bool = false
}

struct ContentView : View {

    @EnvironmentObject var appState: AppState
    
    var body: some View {
        return Drawer(sliderState: self.$appState.sliderState)
            .setSlider(view: SliderView(type: .leftRear, appState: appState), initialShowStatus: self.appState.sliderState[.leftRear] ?? .hide)
            .setSlider(view: Slider2View(type: .rightFront))
            .setMain(view: HomeView().environmentObject(appState))
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
