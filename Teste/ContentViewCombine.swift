//
//  ContentViewCombine.swift
//  Teste
//
//  Created by Laura Corssac on 7/16/22.
//

// The model used is the same simple struct as used on ContentView2
// The communication between the View Models is done with a CurrentValueSubject of
// SimpleStruct
// ParentViewCombineVM communicates the changes in the subject to the view with another @Published property. It assigns the subject to the published
// ChildViewCombine is updated without any of additional setup on its viewModel. I don't know exacly why. 

import SwiftUI
import Combine


class ChildViewCombineVM {
    
    var structObserver: CurrentValueSubject<SimpleStruct, Never>
    
    init(structObserver: CurrentValueSubject<SimpleStruct, Never>) {
        self.structObserver = structObserver
    }
    
    func increment() {
        structObserver.send(SimpleStruct(counter: structObserver.value.counter + 1))
    }
    
    func decrement() {
        structObserver.send(SimpleStruct(counter: structObserver.value.counter - 1))
    }
    
}

struct ChildViewCombine: View {
    
    let vm: ChildViewCombineVM
    
    var body: some View {
        
        Stepper {
            Text("Counter = \(vm.structObserver.value.counter)")
        } onIncrement: {
            vm.increment()
        } onDecrement: {
            vm.decrement()
        }.padding()
        
    }
    
}

class ParentViewCombineVM: ObservableObject {
    
    private let structSubject: CurrentValueSubject<SimpleStruct, Never>
    @Published var structPublished: SimpleStruct
    
    var stepperVM: ChildViewCombineVM {
        .init(structObserver: self.structSubject)
    }
    
    init() {
        let myStruct = SimpleStruct(counter: 0)
        self.structPublished = myStruct
        self.structSubject = .init(myStruct)
        self.structSubject.assign(to: &$structPublished)
        
    }
    
}

struct ParentViewCombine: View {
    
    @ObservedObject var vm: ParentViewCombineVM
    
    var body: some View {
        VStack {
            Text("Step Count = \(vm.structPublished.counter)")
            ChildViewCombine(vm: vm.stepperVM)
        }
        
    }
}

struct ParentViewCombine_Previews: PreviewProvider {
    static var previews: some View {
        ParentViewCombine(vm: .init())
    }
}
