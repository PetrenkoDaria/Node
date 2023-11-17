//
//  NodeListView.swift
//  Node
//
//  Created by Дарья Петренко on 14.11.2023.
//

import SwiftUI
import RealmSwift

struct NodeListView: View {
    @ObservedRealmObject var node: Node
    
    var body: some View {
        List {
            ForEach(node.children, id: \.self) { child in
                NavigationLink(destination: NodeListView(node: child)) {
                    Text(child.name)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationBarTitle(node.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { //Добавление нового узла
                    let newNode = Node()
                    newNode.name = newNode.generateRandomName()
                    $node.children.append(newNode)
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    //Удаление узла
    private func delete(at offsets: IndexSet) {
        for i in offsets {
            if let nodes = $node.children.wrappedValue[i].thaw() {
                try? nodes.realm?.write {
                    Node().deleteCascade(parent: nodes, realm: nodes.realm)
                }
            }
            $node.children.remove(atOffsets: offsets)
        }
    }
}
