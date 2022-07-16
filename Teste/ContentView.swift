//
//  ContentView.swift
//  Teste
//
//  Created by Laura Corssac on 7/15/22.
//

import SwiftUI
import Combine

class SimpleStructReactive: ObservableObject {
    @Published var counter: Int

    init(counter: Int) {
        self.counter = counter
    }

}

class StepperViewViewModel: ObservableObject {

    var simpleStruct: SimpleStructReactive
    @Published var step: Int

    init(simpleStruct: SimpleStructReactive) {
        self.simpleStruct = simpleStruct
        step = simpleStruct.counter
        simpleStruct.$counter.assign(to: &$step)

    }

    func increment() {
        simpleStruct.counter += 1
    }

    func decrement() {
        simpleStruct.counter -= 1
    }
}

struct StepperView: View {

    @ObservedObject var vm: StepperViewViewModel

    var body: some View {
        Stepper {
            Text("Counter = \(vm.step)")
                } onIncrement: {
                    vm.increment()
                } onDecrement: {
                    vm.decrement()
                }
                .padding()

    }
}

class ContentViewViewModel: ObservableObject {

    let stepperViewModel: StepperViewViewModel
    var simpleStruct: SimpleStructReactive
    private var cancellableBag = Set<AnyCancellable>()
    

    init() {
        let simpleStruct = SimpleStructReactive(counter: 0)
        //simpleStructPublished = simpleStruct
        self.simpleStruct = simpleStruct
        self.stepperViewModel = .init(simpleStruct: simpleStruct)
        
        simpleStruct.$counter.sink { [weak self] hey in
            self?.objectWillChange.send()
        }.store(in: &cancellableBag)
        
    }

}

struct ContentView: View {

    @ObservedObject var vm: ContentViewViewModel

    var body: some View {

        VStack {
            Text("Step Count = \(vm.simpleStruct.counter)")
                .padding()
            StepperView(vm: vm.stepperViewModel)
        }

    }

}

struct ContentView_Previews: PreviewProvider {


    static var previews: some View {
        ContentView(vm: ContentViewViewModel())
    }
}
