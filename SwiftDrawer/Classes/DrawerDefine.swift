//
//  Copyright © 2019 Millman, 2020 An Tran. All rights reserved.
//

import Foundation
import SwiftUI

public enum SliderType {
    case leftRear
    case leftFront
    case none
    
    var isLeft: Bool {
        return self == .leftRear || self == .leftFront
    }
    
    var isRear: Bool {
        return self == .leftRear
    }
}

public enum SliderWidth {
    case width(value: CGFloat)
    case percent(rate: CGFloat)
}

public enum ShowStatus: Equatable {
    case show
    case hide
    case moving(offset: CGFloat)
    
    var isMoving: Bool {
        switch self {
        case .moving(_):
            return true
        default:
            return false
        }
    }
}

public protocol SliderProtocol {
    var type: SliderType {get}
}

public typealias SliderViewProtocol = (View & SliderProtocol)
