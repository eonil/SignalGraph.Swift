//
//  ValueStorage.swift
//  SG4
//
//  Created by Hoon H. on 2015/06/28.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

public class ValueStorage<T>: StateStorageType {
	typealias	Element			=	T
	typealias	Snapshot		=	T
	typealias	Transaction		=	T
	typealias	OutgoingSignal		=	StateSignal<Snapshot,Transaction>

	///

	public init(_ snapshot: Snapshot) {
		_snapshot	=	snapshot
	}

	public var snapshot: Snapshot {
		get {
			return	_snapshot
		}
		set(v) {
			_relay.cast(OutgoingSignal.willEnd(_snapshot, by: nil))

			_relay.cast(OutgoingSignal.didBegin(_snapshot, by: nil))
		}
	}
	public func apply(transaction: Transaction) {
		_relay.cast(StateSignal.willEnd(_snapshot, by: transaction))
		_snapshot	=	transaction
		_relay.cast(StateSignal.didBegin(_snapshot, by: transaction))
	}
	public func register(identifier: ObjectIdentifier, handler: OutgoingSignal->()) {
		_relay.register(identifier, handler: handler)
		_relay.cast(StateSignal.didBegin(_snapshot, by: nil))
	}
	public func deregister(identifier: ObjectIdentifier) {
		_relay.cast(StateSignal.willEnd(_snapshot, by: nil))
		_relay.deregister(identifier)
	}
	public func register<S : SensitiveStationType where S.IncomingSignal == OutgoingSignal>(s: S) {
		_relay.register(s)
		_relay.cast(StateSignal.didBegin(_snapshot, by: nil))
	}
	public func deregister<S : SensitiveStationType where S.IncomingSignal == OutgoingSignal>(s: S) {
		_relay.cast(StateSignal.willEnd(_snapshot, by: nil))
		_relay.deregister(s)
	}


	///

	private var	_snapshot	:	Snapshot
	private let	_relay		=	Relay<OutgoingSignal>()
}
extension ValueStorage: Editable, SequenceType {
	public func generate() -> GeneratorOfOne<Snapshot> {
		return	GeneratorOfOne(_snapshot)
	}
}

