//
//  ContentView.swift
//  DrawerDemo
//
//  Created by Millman on 2019/6/25.
//  Copyright © 2019 Millman. All rights reserved.
//

import SwiftUI
import SwiftDrawer

struct ContentView : View {
    
    @State var sliderState: [SliderType: ShowStatus] = [.leftRear: .hide, .rightFront: .hide]
    
    var body: some View {
        return Drawer(sliderState: self.$sliderState)
            .setSlider(view: SliderView(type: .leftRear), initialShowStatus: self.sliderState[.leftRear] ?? .hide)
            .setSlider(view: Slider2View(type: .rightFront))
            .setMain(view: HomeView())
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
