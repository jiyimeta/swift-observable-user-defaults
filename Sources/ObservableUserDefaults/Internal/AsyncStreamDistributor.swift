import Foundation
import os

public final class AsyncStreamDistributor<T>: Sendable {
    typealias Continuation = AsyncStream<T>.Continuation

    private let continuations = OSAllocatedUnfairLock(initialState: [UUID: Continuation]())

    public init() {}

    public func makeStream() -> AsyncStream<T> {
        let stream = AsyncStream<T> { continuation in
            let id = UUID()
            continuations.withLock {
                $0[id] = continuation
            }
            continuation.onTermination = { [weak self] _ in
                self?.continuations.withLock {
                    $0[id] = nil
                }
            }
        }
        return stream
    }

    public func yield(_ value: T) {
        continuations.withLock {
            for continuation in $0.values {
                continuation.yield(value)
            }
        }
    }

    public func finishAll() {
        // When executing continuation.finish, self.remove(id:) will be executed with lock.
        for continuation in continuations.withLock(\.values) {
            continuation.finish()
        }

        continuations.withLock {
            $0.removeAll()
        }
    }
}
