//
//  ViewModelProtocol.swift
//  ToDo
//
//  Created by Aimee Esler on 3/26/23.
//

import Foundation

protocol ViewModelProtocol: ObservableObject {
    associatedtype ViewState
    associatedtype Action
    
    var state: ViewState { get set }
    func onAction(_ action: Action)
}
