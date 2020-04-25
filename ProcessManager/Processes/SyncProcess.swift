//
//  SyncProcess.swift
//  ProcessManager
//
//  Created by Tomasz Korab on 25/04/2020.
//  Copyright © 2020 Tomasz Korab. All rights reserved.
//

import Foundation

open class SyncProcess: Process {

    // MARK: - Properties
    let block: () -> Void

    // MARK: - Inits
    public init(block: @escaping () -> Void) {
        self.block = block
    }

    // MARK: - Overridden Methods
    open override func execute(on thread: DispatchQueue, _ completion: @escaping () -> Void) {
        block()
        completion()
    }

}
