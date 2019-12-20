//
//  Result.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/5/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


func identity<Success>(_ value: Success) -> Success {
    return value
}

func empty<Success>(_ value: Success) -> Success? {
    return nil
}

func liftValue<Success, Failure>(_ value: Success) -> Result<Success, Failure> {
    return .success(value)
}

func liftError<Success, Failure>(_ error: Failure) -> Result<Success, Failure> {
    return .failure(error)
}


extension Result {

    public func mapBoth<NewSuccess, NewFailure>(
        ifSuccess: (Success) -> NewSuccess,
        ifFailure: (Failure) -> NewFailure
    ) -> Result<NewSuccess, NewFailure> {
        withoutActuallyEscaping(ifSuccess) { (ifSuccess) -> Result<NewSuccess, NewFailure> in
            withoutActuallyEscaping(ifFailure) { (ifFailure) -> Result<NewSuccess, NewFailure> in
                return self.flatMapBoth(ifSuccess: ifSuccess • liftValue, ifFailure: ifFailure • liftError)
            }
        }
    }

    public func flatMapBoth<NewSuccess, NewFailure>(
        ifSuccess: (Success) -> Result<NewSuccess, NewFailure>,
        ifFailure: (Failure) -> Result<NewSuccess, NewFailure>
    ) -> Result<NewSuccess, NewFailure> {
        return self.analyze(ifSuccess: ifSuccess, ifFailure: ifFailure)
    }
    
    public func analyzeSuccess<Result>(_ ifSuccess: (Success) -> Result) -> Result? {
        switch self {
        case let .success(value): return ifSuccess(value)
        default: return nil
        }
    }
    
    public func analyzeFailure<Result>(_ ifFailure: (Failure) -> Result) -> Result? {
        switch self {
        case let .failure(error): return ifFailure(error)
        default: return nil
        }
    }
    
    public func analyze<Result>(ifSuccess: (Success) -> Result, ifFailure: (Failure) -> Result) -> Result {
        switch self {
        case let .success(value): return ifSuccess(value)
        case let .failure(error): return ifFailure(error)
        }
    }

}
