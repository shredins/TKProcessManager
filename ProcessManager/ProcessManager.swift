//
//  ProcessManager.swift
//  ProcessManager
//
//  Created by Tomasz Korab on 11/04/2020.
//  Copyright © 2020 Tomasz Korab. All rights reserved.
//

import Foundation

public class ProcessManager {

    // MARK: - Public Static Properties
    public static let shared = ProcessManager()

    // MARK: - Private Properties
    private var processes: [Process] = []
    private let processesThread = DispatchQueue(label: "thread-safe-threadSafeProcesses")
    private var threads: [DispatchQueue] = []
    private let threadsThread = DispatchQueue(label: "thread-safe-threadSafeThreads")

    // MARK: - Computed Properties
    var threadSafeProcesses: [Process] {
        get {
            processesThread.sync {
                processes
            }
        }
        set {
            processesThread.async(flags: .barrier) {
                self.processes = newValue
            }
        }
    }

    var threadSafeThreads: [DispatchQueue] {
        get {
            threadsThread.sync {
                threads
            }
        }
        set {
            threadsThread.async(flags: .barrier) {
                self.threads = newValue
            }
        }
    }

    // MARK: - Public Instance Methods
    public func add(process: Process...) {
        add(newProcesses: process)
    }

    public func add(newProcesses: [Process]) {
        threadSafeProcesses.append(contentsOf: newProcesses)
        prepare()
    }

}

// MARK: - Get-only Properties
private extension ProcessManager {

    var hasAnyProcessInQueue: Bool {
        !threadSafeProcesses.isEmpty
    }

    var hasFreeThreads: Bool {
        threadSafeThreads.count < availableCoresCount
    }

    var availableCoresCount: Int {
        ProcessInfo.processInfo.activeProcessorCount - 1
    }

}

// MARK: - Private Instance Methods
private extension ProcessManager {

    func prepare() {
        while hasAnyProcessInQueue {
            if let newDispatchQueue = createDispatchQueueIfNeeded() {
                executeIfNeeded(on: newDispatchQueue)
            } else {
                break
            }
        }
    }

    func executeIfNeeded(on thread: DispatchQueue) {
        if hasAnyProcessInQueue {
            let process = threadSafeProcesses.removeFirst()

            thread.async {
                let group = DispatchGroup()
                group.enter()
                process.execute(on: thread) {
                    group.leave()
                }

                group.notify(queue: thread) { [unowned self] in
                    self.executeIfNeeded(on: thread)
                }
            }
        } else {
            remove(thread: thread)
        }
    }

    func createDispatchQueueIfNeeded() -> DispatchQueue? {
        if threadSafeThreads.count < availableCoresCount {
            let label = "tomasz.korab.process-manager-\(threadSafeThreads.count)"
            let newDispatchQueue = DispatchQueue(label: label)
            threadSafeThreads.append(newDispatchQueue)
            return newDispatchQueue
        }

        return nil
    }

    func remove(thread: DispatchQueue) {
        threadSafeThreads.removeAll(where: {
            $0.label == thread.label
        })
    }

}
