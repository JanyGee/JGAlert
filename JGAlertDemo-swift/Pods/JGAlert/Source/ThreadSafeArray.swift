//
//  ThreadSafeArray.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/27.
//

import Foundation

final class ThreadSafeArray<Element> {

    private var storage: [Element] = []
    private let queue = DispatchQueue(label: "com.jg.threadSafeArray")

    var count: Int {
        queue.sync { storage.count }
    }

    func append(_ element: Element) {
        queue.sync {
            storage.append(element)
        }
    }

    func insert(_ element: Element, at index: Int) {
        queue.sync {
            guard index <= storage.count else { return }
            storage.insert(element, at: index)
        }
    }

    func removeFirst() {
        queue.sync {
            guard !storage.isEmpty else { return }
            _ = storage.removeFirst()
        }
    }

    func removeAll() {
        queue.sync {
            storage.removeAll()
        }
    }

    func first() -> Element? {
        queue.sync {
            storage.first
        }
    }

    func snapshot() -> [Element] {
        queue.sync {
            storage
        }
    }
    
    func max(by areInIncreasingOrder: (Element, Element) -> Bool) -> Element? {
            queue.sync {
            storage.max(by: areInIncreasingOrder)
        }
    }
}

extension ThreadSafeArray where Element: Equatable {
    func removeAll(_ element: Element) {
        queue.sync {
            storage.removeAll { $0 == element }
        }
    }
}
