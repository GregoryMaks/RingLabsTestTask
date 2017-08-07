//
//  FunctionalComposition.swift
//  RingTask
//
//  Created by Hryhorii Maksiuk on 8/6/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//


precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}


infix operator • : CompositionPrecedence


func •<A, B, C>(lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}
