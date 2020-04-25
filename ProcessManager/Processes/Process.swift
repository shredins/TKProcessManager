//
//  Process.swift
//  ProcessManager
//
//  Created by Tomasz Korab on 11/04/2020.
//  Copyright © 2020 Tomasz Korab. All rights reserved.
//

import Foundation

open class Process {

    // MARK: - Public Instance Methods
    /// Override to execute process. Remember about calling complete closure
    open func execute(on thread: DispatchQueue, _ completion: @escaping () -> Void) {
        assertionFailure("Using execute() method before being initialized")
    }

}
