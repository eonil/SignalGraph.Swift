//
//  main.swift
//  Channel3
//
//  Created by Hoon H. on 2015/05/05.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

println("Hello, World!")






//
//enum ProxyProcessingState<Progress,Reason> {
//	case Running(()->Progress)
//	case Done
//	case Error(()->Reason)
//}
//
//class ProxyCollection<T> {
//	///	`false` if no synchroniztion has been made, so current collection state is actually unknown.
//	var ready: ValueStorage<Bool> {
//		get {
//			return	readyRepo
//		}
//	}
//	///	A flag to represent whether some asynchronous I/O to mutate the `items` are currently running.
//	var	running: ValueStorage<Bool> {
//		get {
//			return	runningRepo
//		}
//	}
//	///	Any error from last I/O operation.
//	var	error: ValueStorage<NSError?> {
//		get {
//			return	errorRepo
//		}
//	}
//	///	Current in-memory local copy(cache) of items.
//	var	items: ArrayStorage<T> {
//		get {
//			return	itemsRepo
//		}
//	}
//	
//	init() {
//		ready.state
//	}
//	
//	///	Makes this to un-ready state.
//	func purge() {
//		
//	}
//	///
//	func reload() {
//		
//	}
//	
//	////
//	
//	private let	readyRepo	=	ValueReplication<Bool>(false)
//	private let	runningRepo	=	ValueReplication<Bool>(false)
//	private let	errorRepo	=	ValueReplication<NSError?>(nil)
//	private let	itemsRepo	=	ArrayReplication<T>()
//}
//
//
//
//
//
//
//let	c	=	ProxyCollection<Int>()
//
//let	s	=	SignalMonitor<ArraySignal<Int>> { (s: ArraySignal<Int>) -> () in
//	switch s {
//	case .Initiation(let s):
//		println(s)
//	case .Transition(let t):
//		for m in t.mutations {
//			println(m)
//		}
//	case .Termination(let s):
//		println(s)
//	}
//}
////var	e	=	ArrayEditor<Int>()
////e.emitter.register(s)
////e.emitter.register(c.itemsRepo.sensor)
////e.append(123123)
//
//
//
//
/////	TODO:	Add single-session assertions to array monitor class.
//
//


func orderOf(e:(String,String)) -> String {
	return	e.0
}

let	dic1	=	DictionaryReplication<String,String>()
let	arr2	=	DictionarySignalSortingArrayMap(orderOf)
dic1.emitter.register(arr2.sensor)

typealias	M	=	CollectionTransaction<String, String>.Mutation
let			ms	=	[
	M("A", nil, "Apple"),
	M("C", nil, "Crap"),
	M("B", nil, "Blues"),
]

let	t	=	CollectionTransaction(mutations: ms)
let	s	=	DictionarySignal.Transition(transaction: t)

dic1.sensor.signal(s)
println(arr2.array.state)

















