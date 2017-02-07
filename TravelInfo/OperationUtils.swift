//
//  OperationUtils.swift
//  TravelInfo
//
//  Created by Patrick Lynch on 2/3/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import Foundation

/// An extension of `Operation` that (1) uses a static share queue so that calling code
/// is not required to declare, define and manage a reference to a simple operation queue,
/// and (2) creates a simplified API wrapper around `OperationQueue` for easily queueing
/// and adding a completion block that executes on the main thread (instead of the queue/thread
/// upon which the operation is executing.
class QueueableOperation: Operation {
    
    private static var sharedQueue: OperationQueue = Foundation.OperationQueue()
    
    weak var defaultQueue: OperationQueue! = QueueableOperation.sharedQueue
    
    /// Adds the operation to a background queue shared by all subclasses of `QueuableOperation`
    /// Sets up the provided `mainQueueCompletionBlock` to be executed on the main thread
    /// when the operation's `completionBlock` variable is normally called.
    func queue(mainQueueCompletionBlock: (()->())? = nil) {
        if let mainQueueCompletionBlock = mainQueueCompletionBlock {
            completionBlock = {
                DispatchQueue.main.async {
                    mainQueueCompletionBlock()
                }
            }
        }
        defaultQueue!.addOperation(self)
    }
}

/// A subclass of `Operation` that uses semaphores to create asynchronous
/// behavior that starts and stops with simple method calls.
class AsyncOperation: QueueableOperation {
    
    private let semaphore = DispatchSemaphore(value: 0)
    
    func execute() {
        assertionFailure("Please implement this method in a subclass.")
    }
    
    override func main() {
        execute()
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    final func didFinish() {
        semaphore.signal()
    }
    
    override func cancel() {
        super.cancel()
        didFinish()
    }
}
