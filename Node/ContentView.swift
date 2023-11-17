//
//  ContentView.swift
//  Node
//
//  Created by Дарья Петренко on 14.11.2023.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @ObservedResults(Node.self) var nodes
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(nodes.filter({ $0.parent.isEmpty }), id: \.self) { node in //Вывод только корневых узлов
                    NavigationLink(destination: NodeListView(node: node)) {
                        Text(node.name)
                    }
                }.onDelete { Node().delete(at: $0, from: $nodes) }
            }
            .navigationBarTitle("Root")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { //Добавление нового корневого узла
                        let newNode = Node()
                        newNode.name = newNode.generateRandomName()
                        $nodes.append(newNode)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
