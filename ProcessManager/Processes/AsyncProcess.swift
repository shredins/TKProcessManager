//
//  AsyncProcess.swift
//  ProcessManager
//
//  Created by Tomasz Korab on 20/04/2020.
//  Copyright © 2020 Tomasz Korab. All rights reserved.
//

import Foundation

open class AsyncProcess: Process {

    // MARK: - Properties
    let block: (DispatchQueue, @escaping () -> Void) -> Void

    // MARK: - Inits
    public init(block: @escaping (DispatchQueue, @escaping () -> Void) -> Void) {
        self.block = block
    }

    // MARK: - Overridden Methods
    open override func execute(on thread: DispatchQueue, _ completion: @escaping () -> Void) {
        block(thread, completion)
    }

}
