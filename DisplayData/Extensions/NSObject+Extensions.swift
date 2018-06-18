//
//  NSObject+Extensions.swift
//  Kollectin
//
//  Created by Umair Ali on 5/9/17.
//  Copyright © 2017 Pablo. All rights reserved.
//

import UIKit

extension NSObject {

    func performBlockOnMainThread(_ blockMethod : @escaping (() -> Void) , afterDelay : Double = 0) {
        let delayTime = DispatchTime.now() + Double(Int64(afterDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            blockMethod()
        }
    }
    
    func performBlockOnBackgroundThread(_ blockMethod : @escaping (() -> Void) , afterDelay : Double) {
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let delayTime = DispatchTime.now() + Double(Int64(afterDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.global(qos: qualityOfServiceClass).asyncAfter(deadline: delayTime) {
            blockMethod()
        }
    }
}
