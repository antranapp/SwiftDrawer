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
                    }))
                
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

struct HomeView2: View {
    @State private var users = ["Paul", "Taylor", "Adele"]
    
    @EnvironmentObject public var appState: AppState

    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.self) { user in
                    Button(action: {
                        print(user)
                        print(self.appState.sliderState[.leftRear].debugDescription)
                    }) {
                        Text(user)
                    }
                }
                .onMove(perform: move)
                .onDelete { _ in }
            }
            .disabled(self.appState.sliderState[.leftRear] == .show)
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, self.$appState.editMode)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
}

#if DEBUG
struct HomeView_Previews : PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
