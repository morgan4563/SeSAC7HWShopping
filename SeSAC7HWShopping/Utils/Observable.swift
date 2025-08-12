//
//  Observable.swift
//  SeSAC7HWShopping
//
//  Created by hyunMac on 8/12/25.
//

final class Observable<T> {
    private var closure: ((T) -> Void)?

    var value: T {
        didSet {
            closure?(value)
        }
    }

    init(value: T) {
        self.value = value
    }

    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }

    func lazyBind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}
