//
//  Drawer.swift
//  DrawerDemo
//
//  Created by Millman on 2019/6/25.
//  Copyright © 2019 Millman. All rights reserved.
//

import SwiftUI
import Combine

public struct Drawer: View {
    
    @ObservedObject var drawerControl = DrawerControl()
    
    @Binding var sliderState: [SliderType: ShowStatus]
    
    public init(sliderState: Binding<[SliderType: ShowStatus]>) {
        _sliderState = sliderState
    }
    
    public var body: some View {
        ZStack {
            drawerControl.sliderView[.leftRear]
            drawerControl.sliderView[.rightRear]
            drawerControl.main
            drawerControl.sliderView[.rightFront]
            drawerControl.sliderView[.leftFront]
        }
        .onReceive(drawerControl.showStatusSignal) { status in
            self.sliderState[status.0] = status.1
        }
    }
    
    @discardableResult
    public func setMain<Main: View>(view: Main) -> Drawer {
        drawerControl.setMain(view: view)
        return self
    }
    
    @discardableResult
    public func setSlider<Slider: SliderViewProtocol>(view: Slider,
                                                      widthType: SliderWidth = .percent(rate: 0.6),
                                                      shadowRadius: CGFloat = 10,
                                                      initialShowStatus: ShowStatus = .hide) -> Drawer{
        drawerControl.setSlider(
            view: view,
            widthType: widthType,
            shadowRadius: shadowRadius,
            initialShowStatus: initialShowStatus
        )
        return self
    }
}

#if DEBUG
public struct DemoMain: View {
    public var body: some View {
        Text("AAA")
    }
}

public struct DemoSlider: View, SliderProtocol {
    public var body: some View {
        Text("Slider")
    }
    public let type: SliderType
    public init(type: SliderType) {
        self.type = type
    }

}

struct Drawer_Previews : PreviewProvider {
    
    static var previews: some View {
        Drawer(sliderState: .constant([.leftRear: .hide]))
            .setMain(view: DemoMain())
            .setSlider(view: DemoSlider(type: .leftRear), initialShowStatus: .hide)
    }
}
#endif
