//
//  Copyright © 2019 Millman, 2020 An Tran. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public typealias SliderShowStatusSignal = (SliderType, ShowStatus)
public typealias SliderShowStatus = [SliderType: SliderStatus]

public class DrawerControl: ObservableObject {

    public let showStatusSignal = PassthroughSubject<SliderShowStatusSignal, Never>()
    
    private var statusObserver = [AnyCancellable]()
    
    public private(set) var status = SliderShowStatus() {
        didSet {
            statusObserver.forEach {
                $0.cancel()
            }
            statusObserver.removeAll()
            
            status.forEach { info in
                let observer = info.value.objectDidChange.sink { [weak self] s in
                    let maxRate = self?.status.sorted { (s0, s1) -> Bool in
                        s0.value.showRate > s1.value.showRate
                    }.first?.value.showRate ?? 0
                    
                    if self?.maxShowRate == maxRate {
                        return
                    }
                    self?.maxShowRate = maxRate
                }
                statusObserver.append(observer)
            }
        }
    }
    @Published
    private(set) var sliderView = [SliderType: AnyView]()
    
    @Published
    private(set) var main: AnyView?
    
    @Published
    private(set) var maxShowRate: CGFloat = .zero
    
    public func setSlider<Slider: SliderViewProtocol>(view: Slider,
                                                      widthType: SliderWidth,
                                                      shadowRadius: CGFloat,
                                                      initialShowStatus: ShowStatus) {
        let status = SliderStatus(type: view.type, initialShowStatus: initialShowStatus)
        
        status.maxWidth = widthType
        status.shadowRadius = shadowRadius
        self.status[view.type] = status
        self.sliderView[view.type] = AnyView(SliderContainer(content: view, drawerControl: self))
    }

    public func setMain<Main: View>(view: Main, configuration: Configuration = Configuration()) {
        let container = MainContainer(content: view, drawerControl: self, configuration: configuration)
        self.main = AnyView(container)
    }
    
    public func show(type: SliderType, isShow: Bool) {
        
        let haveMoving = self.status.first { $0.value.currentStatus.isMoving } != nil
        if haveMoving {
            return
        }
        
        let currentStatus: ShowStatus = isShow ? .show: .hide
        self.status[type]?.currentStatus = currentStatus
        
        showStatusSignal.send((type, currentStatus))
    }
    
    public func hideAllSlider() {
        self.status.forEach {
            $0.value.currentStatus = .hide
            showStatusSignal.send(($0.key, .hide))
        }
    }
}
