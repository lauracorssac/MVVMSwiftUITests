//
//  ParentViewBinding.swift
//  Teste
//
//  Created by Laura Corssac on 7/15/22.
//

// ChildViewVM2 has a @Binding, which makes possible to the view get updated when a change occurs and also the ParentViewVM2 receive the changes

import SwiftUI
import Combine

struct SimpleStruct {
    var counter: Int
    
    init(counter: Int) {
        self.counter = counter
    }
    
}

class ChildViewBindingVM {
    
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

struct ChildViewBinding: View {
    
    var vm: ChildViewBindingVM
    
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

class ParentViewBindingVM: ObservableObject {
    
    @Published var simpleStruct: SimpleStruct
    private var cancellableBag = Set<AnyCancellable>()
    
    var binding: Binding<SimpleStruct> {
        Binding(
            get: { self.simpleStruct },
            set: { self.simpleStruct = $0 }
        )
    }
    
    var stepperViewModel: ChildViewBindingVM {
        .init(simpleStruct: binding)
    }
    
    init() {
        let simpleStruct = SimpleStruct(counter: 0)
        self.simpleStruct = simpleStruct
        
    }
    
}

struct ParentViewBinding: View {
    
    @ObservedObject var vm: ParentViewBindingVM
    
    var body: some View {
        
        VStack {
            Text("Step Count = \(vm.simpleStruct.counter)")
                .padding()
            ChildViewBinding(vm: vm.stepperViewModel)
        }
        
    }
    
}

struct ParentViewBinding_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ParentViewBinding(vm: .init())
    }
}
