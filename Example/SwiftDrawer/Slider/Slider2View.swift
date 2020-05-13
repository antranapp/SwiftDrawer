//
//  Slider2View.swift
//  SwiftDrawer_Example
//
//  Created by Millman on 2019/7/2.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftDrawer
struct Slider2View : View, SliderProtocol {
    var body: some View {
        Text("Slider 2 View!")
    }
    let type: SliderType
    init(type: SliderType) {
        self.type = type
    }

}
