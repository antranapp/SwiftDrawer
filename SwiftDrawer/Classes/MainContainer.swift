//
//  Copyright © 2019 Millman, 2020 An Tran. All rights reserved.
//

import SwiftUI
import Combine

struct MainContainer<Content: View> : View {
    
    @ObservedObject private var drawerControl: DrawerControl
    @ObservedObject private var leftRear: SliderStatus
    
    @State private var gestureCurrent: CGFloat = 0
    
    let main: AnyView
    private var maxMaskAlpha: CGFloat
    private var maskEnable: Bool
    var anyCancel: AnyCancellable?
    private var isDragGestureEnabled: Bool
    
    init(content: Content,
         maxMaskAlpha: CGFloat = 0.25,
         maskEnable: Bool = true,
         drawerControl: DrawerControl,
         isDragGestureEnabled: Bool = true) {
        
        self.main = AnyView.init(content.environmentObject(drawerControl))
        self.maxMaskAlpha = maxMaskAlpha
        self.maskEnable = maskEnable
        self.drawerControl = drawerControl
        self.leftRear = drawerControl.status[.leftRear] ?? SliderStatus(type: .none)
        self.isDragGestureEnabled = isDragGestureEnabled
    }
    
    var body: some View {
        GeometryReader { proxy in
            self.generateBody(proxy: proxy)
        }.animation(.default)
    }
    
    // MARK: PRivate helpers
    
    private func generateBody(proxy: GeometryProxy) -> some View {
        return generateBaseView(proxy)
            .ifConditional(isDragGestureEnabled) {
                $0.gesture(DragGesture()
                    .onChanged { (value) in
                        let will = self.offset + (value.translation.width-self.gestureCurrent)
                        if self.leftRear.type != .none {
                            
                            // Fix the bug when users swipe in both direction,
                            // then `onEnded` will not be called.
                            guard abs(value.translation.height) < 5.0 else { return }
                            
                            let range = 0...self.leftRear.sliderWidth
                            
                            var shouldMove: Bool {
                                switch self.leftRear.currentStatus {
                                    case .show, .moving: return true
                                    case .hide: return value.startLocation.x < 10
                                }
                            }
                            
                            if range.contains(will) && shouldMove {
                                self.leftRear.currentStatus = .moving(offset: will)
                                self.gestureCurrent = value.translation.width
                            }
                        }
                    }
                    .onEnded { (value) in
                        let will = self.offset + (value.translation.width-self.gestureCurrent)
                        
                        if self.leftRear.type != .none {
                            switch self.leftRear.currentStatus {
                                case .moving:
                                    let range = 0...self.leftRear.sliderWidth
                                    self.leftRear.currentStatus = will-range.lowerBound > range.upperBound-will ? .show : .hide
                                    self.drawerControl.show(type: .leftRear, isShow: self.leftRear.currentStatus == .show)
                                default: break
                            }
                        }
                        
                        self.gestureCurrent = 0
                    }
                )
            }

    }
    
    private func generateBaseView(_ proxy: GeometryProxy) -> some View {
        
        let haveRear = self.leftRear.type != .none
        let maxRadius = haveRear ? self.leftRear.shadowRadius : 0
        let parentSize = proxy.size
        if haveRear {
            leftRear.parentSize = parentSize
        }
        
        return
            ZStack {
                self.main
                if maskEnable {
                    Color.black.opacity(Double(drawerControl.maxShowRate*self.maxMaskAlpha))
                        .animation(.easeIn(duration: 0.15))
                        .onTapGesture {
                            self.drawerControl.hideAllSlider()
                    }.padding(EdgeInsets(top: -proxy.safeAreaInsets.top, leading: 0, bottom: -proxy.safeAreaInsets.bottom, trailing: 0))
                }
            }
            .offset(x: self.offset, y: 0)
            .shadow(radius: maxRadius)
    }
    
    var offset: CGFloat {
        switch (self.leftRear.currentStatus) {
        case .hide:
            return 0
        case .show:
            return self.leftRear.sliderOffset()
        default:
            if self.leftRear.currentStatus.isMoving {
                return self.leftRear.sliderOffset()
            }
        }
        return 0
    }
    
    var maxShowRate: CGFloat {
        return self.leftRear.showRate
    }
}

extension View {
    func ifConditional<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}

#if DEBUG
struct MainContainer_Previews : PreviewProvider {
    static var previews: some View {
        self.generate()
    }
    
    static func generate() -> some View {
        let view = DemoSlider.init(type: .leftRear)
        let c = DrawerControl()
        c.setSlider(view: view)
        return MainContainer.init(content: DemoMain(), drawerControl: c)
    }
}
#endif
