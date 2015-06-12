//
//  SetStorage.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/06.
//  Copyright (c) 2015 Eonil. All rights reserved.
//





private final class SetSignalDispatcher<T: Hashable>: SignalDispatcher<SetSignal<T>> {
	weak var owner: SetStorage<T>?
	override func register(sensor: SignalSensor<SetSignal<T>>) {
		Debugging.EmitterSensorRegistration.assertRegistrationOfStatefulChannelingSignaling((self, sensor))
		super.register(sensor)
		if let _ = owner!.values {
			sensor.signal(SetSignal.Initiation(snapshot: owner!.state))
		}
	}
	override func deregister(sensor: SignalSensor<SetSignal<T>>) {
		Debugging.EmitterSensorRegistration.assertDeregistrationOfStatefulChannelingSignaling((self, sensor))
		super.deregister(sensor)
		if let _ = owner!.values {
			sensor.signal(SetSignal.Termination(snapshot: owner!.state))
		}
	}
}











public class SetStorage<T: Hashable>: StorageType {
	
	public var state: Set<T> {
		get {
			return	values!
		}
	}
	
	public var emitter: SignalEmitter<SetSignal<T>> {
		get {
			return	dispatcher
		}
	}
	
	////
	
	private var	values	=	nil as Set<T>?
	
	private init() {
	}
	
	private let	dispatcher	=	SignalDispatcher<SetSignal<T>>()
}

///	A storage that provides indirect signal based mutator.
///
///	Initial state of a state-container is undefined, and you should not access
///	them while this contains is not bound to a signal source.
public class ReplicatingSetStorage<T: Hashable>: SetStorage<T>, ReplicationType {
	
	public override init() {
		super.init()
		monitor.handler	=	{ [unowned self] s in
			s.apply(&self.values)
			self.dispatcher.signal(s)
		}
	}
	
	public var sensor: SignalSensor<SetSignal<T>> {
		get {
			return	monitor
		}
	}
	
	////
	
	private let	monitor		=	SignalMonitor<SetSignal<T>>({ _ in })
}









///	Provides in-place `Set`-like mutator interface.
///	Signal sensor is disabled to guarantee consistency.
public class EditableSetStorage<T: Hashable>: ReplicatingSetStorage<T> {
	public init(_ state: Set<T> = Set()) {
		super.init()
		super.sensor.signal(SetSignal.Initiation(snapshot: state))
	}
	deinit {
		//	Do not send any signal. 
		//	Because any non-strong reference to self is inaccessible here.
		
		//	We don't need to erase owning current state. Because
		//	users must already been removed all sensors from emitter.
		//	Emitter asserts no registered sensors when `deinit`ializes.
	}
	
	@availability(*,unavailable)
	public override var sensor: SignalSensor<SetSignal<T>> {
		get {
			fatalError("You cannot get sensor of this object. Replication from external emitter is prohibited.")
		}
	}
}

extension EditableSetStorage {
	public typealias	Index	=	SetIndex<T>
	
	public func insert(member: T) {
		super.sensor.signal(SetSignal.Transition(transaction: CollectionTransaction.insert((member,()))))
	}
	
	public func remove(member: T) -> T? {
		let	v	=	state.contains(member) ? member : nil as T?
		super.sensor.signal(SetSignal.Transition(transaction: CollectionTransaction.delete((member, ()))))
		return	v
	}
	
	public subscript (position: Index) -> T {
		get {
			return	super.state[position]
		}
	}
}













//
//extension SetStorage: SequenceType {
//	public typealias	Index	=	SetIndex<T>
//
//	///	This is callable only while storage is ready.
//	public func generate() -> SetGenerator<T> {
//		return	values!.generate()
//	}
//}








