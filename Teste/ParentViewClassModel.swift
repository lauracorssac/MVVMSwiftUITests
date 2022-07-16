//
//  ParentViewClassModel.swift
//  Teste
//
//  Created by Laura Corssac on 7/15/22.
//

// Approach with class model ObservableObject (SimpleClass)
// The viewModels get the changes, but without an "extra setup" the View does not
// StepperViewViewModel linked the changes in SimpleClass.counter to a Published property
// ContentViewViewModel manually called objectWillChange when SimpleClass.counter

import SwiftUI
import Combine

class SimpleClass: ObservableObject {
    @Published var counter: Int
    
    init(counter: Int) {
        self.counter = counter
    }
    
}

class ChildViewClassVM: ObservableObject {
    
    var simpleStruct: SimpleClass
    @Published var steps: Int
    
    init(simpleStruct: SimpleClass) {
        self.simpleStruct = simpleStruct
        steps = simpleStruct.counter
        simpleStruct.$counter.assign(to: &$steps)
        
    }
    
    func increment() {
        simpleStruct.counter += 1
    }
    
    func decrement() {
        simpleStruct.counter -= 1
    }
}

struct ChildViewModelClass: View {
    
    @ObservedObject var vm: ChildViewClassVM
    
    var body: some View {
        Stepper {
            Text("Steps = \(vm.steps)")
        } onIncrement: {
            vm.increment()
        } onDecrement: {
            vm.decrement()
        }
        .padding()
        
    }
}

class ParentViewClassVM: ObservableObject {
    
    let stepperViewModel: ChildViewClassVM
    var simpleStruct: SimpleClass
    private var cancellableBag = Set<AnyCancellable>()
    
    
    init() {
        let simpleStruct = SimpleClass(counter: 0)
        self.simpleStruct = simpleStruct
        self.stepperViewModel = .init(simpleStruct: simpleStruct)
        
        simpleStruct.$counter.sink { [weak self] hey in
            self?.objectWillChange.send()
        }.store(in: &cancellableBag)
        
    }
    
}

struct ParentViewClassModel: View {
    
    @ObservedObject var vm: ParentViewClassVM
    
    var body: some View {
        
        VStack {
            Text("Step Count = \(vm.simpleStruct.counter)")
                .padding()
            ChildViewModelClass(vm: vm.stepperViewModel)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ParentViewClassModel(vm: ParentViewClassVM())
    }
}
