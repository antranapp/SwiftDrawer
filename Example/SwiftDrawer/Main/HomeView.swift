//
//  MainView1.swift
//  SwiftDrawer_Example
//
//  Created by Millman on 2019/6/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftDrawer

struct HomeView : View {
    
    @EnvironmentObject public var control: DrawerControl
    
    @EnvironmentObject public var appState: AppState

    var body: some View {
        NavigationView {
            List {
                Text("Home View in Main")
                    .navigationBarTitle(Text("Home"), displayMode: .automatic)
                    .navigationBarItems(leading: Image("menu").onTapGesture(perform: {
                        let leftMenuStatus = self.appState.sliderState[.leftRear] ?? .hide
                        let isShow = leftMenuStatus == .hide
                        self.control.show(type: .leftRear, isShow: isShow)
                    }), trailing: Text("Right").onTapGesture {
                        self.control.show(type: .rightFront, isShow: true)
                    })
                
                Toggle(isOn: self.$appState.isOn) {
                    Text("isOn")
                }

                Button(action: {
                    print(self.appState.sliderState[.leftRear].debugDescription)
                }) { Text("Show appState") }
            }
        }
        .foregroundColor(Color.red)
    }
}

#if DEBUG
struct HomeView_Previews : PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
