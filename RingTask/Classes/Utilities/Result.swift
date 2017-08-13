//
//  Result.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


func identity<Value>(_ value: Value) -> Value {
    return value
}

func empty<Value>(_ value: Value) -> Value? {
    return nil
}

func liftValue<Value, Error>(_ value: Value) -> Result<Value, Error> {
    return .success(value)
}

func liftError<Value, Error>(_ error: Error) -> Result<Value, Error> {
    return .failure(error)
}


enum Result<TValue, TError: Swift.Error> {
    
    case success(TValue)
    case failure(TError)
    
    // MARK: - Public properties
    
    var value: TValue? {
        return self.analysis(ifValue: identity, ifError: { _ in nil })
    }
    
    var error: TError? {
        return self.analysis(ifValue: { _ in nil }, ifError: identity)
    }
    
    // MARK: - Lifecycle
    
    init(value: TValue) {
        self = .success(value)
    }
    
    init(error: TError) {
        self = .failure(error)
    }
    
    init(value: TValue?, failWith error: @autoclosure () -> TError) {
        self = value.map(Result.success) ?? .failure(error())
    }
    
    init(value: TValue?, error: @autoclosure () -> TError) {
        self = value.map(Result.success) ?? .failure(error())
    }
    
    init(_ throwingExpression: () throws -> TValue, errorConverter: (Error) -> TError) {
        do {
            let value = try throwingExpression()
            self = .success(value)
        } catch {
            self = .failure(errorConverter(error))
        }
    }
    
    // MARK: - Public methods
    
    func analysis<Result>(ifValue: (TValue) -> Result, ifError: (TError) -> Result) -> Result {
        switch self {
        case let .success(value): return ifValue(value)
        case let .failure(error): return ifError(error)
        }
    }
    
    // MARK: Raw value related
    
    func map<T, E>(ifSuccess: @escaping (TValue) -> T, ifFailure: @escaping (TError) -> E) -> Result<T, E> {
        return self.flatMap(ifSuccess: ifSuccess • liftValue, ifFailure: ifFailure • liftError)
    }
    
    func mapValue<T>(_ transform: @escaping (TValue) -> T) -> Result<T, TError> {
        return self.map(ifSuccess: transform, ifFailure: identity)
    }
    
    func mapError<E>(_ transform: @escaping (TError) -> E) -> Result<TValue, E> {
        return self.map(ifSuccess: identity, ifFailure: transform)
    }
    
    // MARK: Result value related
    
    func flatMap<T, E>(ifSuccess: @escaping (TValue) -> Result<T, E>, ifFailure: @escaping (TError) -> Result<T, E>) -> Result<T, E> {
        return self.analysis(ifValue: ifSuccess, ifError: ifFailure)
    }
    
    func flatMapValue<T>(transform: @escaping (TValue) -> Result<T, TError>) -> Result<T, TError> {
        return self.flatMap(ifSuccess: transform, ifFailure: liftError)
    }
    
    func flatMapError<E>(transform: @escaping (TError) -> Result<TValue, E>) -> Result<TValue, E> {
        return self.flatMap(ifSuccess: liftValue, ifFailure: transform)
    }
}
