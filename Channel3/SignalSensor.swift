//
//  SignalSensor.swift
//  Channel3
//
//  Created by Hoon H. on 2015/05/05.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

public class SignalSensor<T>: SensorType {
	func signal(s: T) {
		handler(s)
	}
	func subscribe(emitter: AnyObject) {
		assert(self.emitter === nil, "This is a unique channeling sensor, and already registered to an emitter `\(self.emitter!)`. So cannot be registered to another emitter again.")
		self.emitter	=	emitter
	}
	func desubscribe(emitter: AnyObject) {
		assert(self.emitter === emitter, "This is a unique channeling sensor, and can be deregistered only from current emitter `\(self.emitter!)`.")
		self.emitter	=	nil
	}
	
	////
	
	private typealias	In		=	T
	private typealias	Out		=	()
	
	private var			handler	:	T -> ()
	private weak var	emitter	:	AnyObject?
	
	private init(_ handler: T -> ()) {
		self.handler	=	handler
	}
}

public class SignalMonitor<T>: SignalSensor<T>, MonitorType {
	typealias	In		=	T
	typealias	Out		=	()
	typealias	Signal	=	T
	
	public convenience init() {
		self.init({ _ in () })
	}
	
	public override init(_ handler: T -> ()) {
		super.init(handler)
	}
	
	public override var handler: T -> () {
		didSet {
		}
	}
	
	////
	
	override func signal(s: T) {
		super.signal(s)
	}
}














//
//
//public class SingleSessionSignalDispatcher<T>: SignalDispatcher<T>, SingleSessionEmitterType {
//	public override func register<S : SingleSessionSensorType where S.Signal == Signal>(sensor: S) {
//		super.register(sensor)
//		sensor.notifyInitiationOfSensingSessionFor(self)
//	}
//	public override func deregister<S : SingleSessionSensorType where S.Signal == Signal>(sensor: S) {
//		sensor.notifyTerminationOfSensingSessionFor(self)
//		super.deregister(sensor)
//	}
//	
//	@availability(*,unavailable)
//	public override func register<S : SensorType where S.Signal == Signal>(sensor: S) {
//		fatalError()
//	}
//	@availability(*,unavailable)
//	public override func deregister<S : SensorType where S.Signal == Signal>(sensor: S) {
//		fatalError()
//	}
//}
//
//public class SingleSessionSignalMonitor<T>: SignalSensor<T>, SingleSessionSensorType {
//	public func notifyInitiationOfSensingSessionFor<T : EmitterType where T : AnyObject>(emitter: T) {
//		assert(currentEmitter === nil)
//		currentEmitter	=	emitter
//	}
//	public func notifyTerminationOfSensingSessionFor<T : EmitterType where T : AnyObject>(emitter: T) {
//		assert(currentEmitter === emitter)
//		currentEmitter	=	nil
//	}
//	
//	////
//	
//	private weak var	currentEmitter: AnyObject?
//}

