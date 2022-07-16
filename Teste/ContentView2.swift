//
//  ContentView2.swift
//  Teste
//
//  Created by Laura Corssac on 7/15/22.
//

import SwiftUI
import Combine

struct SimpleStruct {
   var counter: Int
    
    init(counter: Int) {
        self.counter = counter
    }
    
}

class StepperViewViewModel2 {
    
    @Binding var simpleStruct: SimpleStruct
    private var cancellableBag = Set<AnyCancellable>()

    init(simpleStruct: Binding<SimpleStruct>) {
        self._simpleStruct = simpleStruct
        
    }
    
    func increment() {
        simpleStruct.counter += 1
    }
    
    func decrement() {
        simpleStruct.counter -= 1
    }
}

struct StepperView2: View {
    
    var vm: StepperViewViewModel2
    
    var body: some View {
        Stepper {
            Text("Counter = \(vm.simpleStruct.counter)")
                } onIncrement: {
                    vm.increment()
                } onDecrement: {
                    vm.decrement()
                }
                .padding()
        
    }
}

class ContentViewViewModel2: ObservableObject {
    
    @Published var simpleStruct: SimpleStruct
    private var cancellableBag = Set<AnyCancellable>()
    
    var binding: Binding<SimpleStruct> {
        Binding(
            get: { self.simpleStruct },
            set: { self.simpleStruct = $0 }
        )
    }
    
    var stepperViewModel: StepperViewViewModel2 {
        StepperViewViewModel2.init(simpleStruct: binding)
    }
    
    init() {
        let simpleStruct = SimpleStruct(counter: 0)
        self.simpleStruct = simpleStruct
        
        
        $simpleStruct.sink { struc in
            print("how", struc.counter)
        }.store(in: &cancellableBag)
    
    }
    
}

struct ContentView2: View {
    
    @ObservedObject var vm: ContentViewViewModel2
    
    var body: some View {
        
        VStack {
            Text("Step Count = \(vm.simpleStruct.counter)")
                .padding()
            StepperView2(vm: vm.stepperViewModel)
        }
        
    }
    
}

struct ContentView2_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ContentView2(vm: ContentViewViewModel2())
    }
}
