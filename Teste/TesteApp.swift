//
//  TesteApp.swift
//  Teste
//
//  Created by Laura Corssac on 7/15/22.
//

import SwiftUI

@main
struct TesteApp: App {
    var body: some Scene {
        WindowGroup {
            //ParentViewBinding(vm: .init())
            //ParentViewCombine(vm: .init())
            ParentViewClassModel(vm: .init())
        }
    }
}
