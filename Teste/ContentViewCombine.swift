//
//  ContentViewCombine.swift
//  Teste
//
//  Created by Laura Corssac on 7/16/22.
//

import SwiftUI
import Combine


class StepperViewCombineVM {
    
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

struct StepperViewCombine: View {
    
    let vm: StepperViewCombineVM
    
    var body: some View {
        
        Stepper {
            Text("Counter = \(vm.structObserver.value.counter)")
                } onIncrement: {
                    vm.increment()
                } onDecrement: {
                    vm.decrement()
                }
                .padding()
        
    }
    
}

class ContentViewCombineVM: ObservableObject {
    
    let structObserver: CurrentValueSubject<SimpleStruct, Never>
    @Published var structPublished: SimpleStruct
    
    var stepperVM: StepperViewCombineVM {
        .init(structObserver: self.structObserver)
    }
    
    init(structObserver: SimpleStruct) {
        self.structPublished = structObserver
        self.structObserver = .init(structObserver)
        self.structObserver.assign(to: &$structPublished)
        
    }
    
}

struct ContentViewCombine: View {
    
    @ObservedObject var vm: ContentViewCombineVM
    
    var body: some View {
        VStack {
            Text("Step Count = \(vm.structObserver.value.counter)")
            StepperViewCombine(vm: vm.stepperVM)
        }
       
    }
}

struct ContentViewCombine_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewCombine(vm: .init(structObserver: .init(counter: 0)))
    }
}
