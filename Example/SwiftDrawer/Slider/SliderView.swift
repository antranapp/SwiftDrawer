//
//  SliderView.swift
//  SwiftDrawer_Example
//
//  Created by Millman on 2019/6/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftDrawer

struct SliderView : View, SliderProtocol {

    @EnvironmentObject public var drawerControl: DrawerControl
    
    @ObservedObject private var appState: AppState

    let type: SliderType
    
    init(type: SliderType, appState: AppState) {
        self.type = type
        self.appState = appState
    }

    var body: some View {
        
        List {
            HeaderView()
            
            SliderCell(imgName: "home", title: "Home").onTapGesture {
                self.drawerControl.setMain(view: HomeView())
                self.drawerControl.show(type: .leftRear, isShow: false)
            }
            
            SliderCell(imgName: "account", title: "Account").onTapGesture {
                self.drawerControl.setMain(view: AccountView())
                self.drawerControl.show(type: .leftRear, isShow: false)
            }

            Toggle(isOn: .init(get: { self.appState.isOn
            }, set: {
                self.appState.isOn = $0
            })) {
                Text("isOn")
            }

            Button(action: {
                print(self.appState.sliderState)
            }, label: { Text("Show State") })
        }
    }
}
