//
//  DependencyContainer.swift
//  RingTask
//
//  Created by Gregory on 8/29/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


/// T has no real sense in usage inside container, its only purpose is typesafety
class DependencyContainer<T> {
    
    private struct ObjectDependency<D> {
        let instantiationFunctor: () -> D
    }
    
    private var nodes: [String: Any] = [:]
    
    func register<T>(_ instantiationBlock: @escaping () -> T) {
        let key = String(describing: T.self)
        let dependency = ObjectDependency(instantiationFunctor: instantiationBlock)
        nodes[key] = dependency
    }
    
    func produce<T>() -> T {
        guard let result = safeProduce() as T? else {
            fatalError("Unable to produce object of type \(String(describing: T.self))")
        }
        return result
    }
    
    func safeProduce<T>() -> T? {
        let key = String(describing: T.self)
        guard let dependency = nodes[key] as? ObjectDependency<T> else {
            return nil
        }
        
        return dependency.instantiationFunctor()
    }
    
}

func dependencyContainerWith<A>(_ aFunctor: @escaping () -> A) -> DependencyContainer<(A)> {
    let container = DependencyContainer<(A)>()
    container.register(aFunctor)
    return container
}

func dependencyContainerWith<A, B>(_ aFunctor: @escaping () -> A,
                                   _ bFunctor: @escaping () -> B) -> DependencyContainer<(A, B)> {
    let container = DependencyContainer<(A, B)>()
    container.register(aFunctor)
    container.register(bFunctor)
    return container
}

func dependencyContainerWith<A, B, C>(_ aFunctor: @escaping () -> A,
                                      _ bFunctor: @escaping () -> B,
                                      _ cFunctor: @escaping () -> C) -> DependencyContainer<(A, B, C)> {
    let container = DependencyContainer<(A, B, C)>()
    container.register(aFunctor)
    container.register(bFunctor)
    container.register(cFunctor)
    return container
}

// On and on...




