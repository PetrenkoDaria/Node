//
//  NodeModel.swift
//  Node
//
//  Created by Дарья Петренко on 15.11.2023.
//

import Foundation
import RealmSwift
import Realm


class Node: Object, Identifiable {
    @Persisted(primaryKey: true) var name: String
    @Persisted var children: List<Node>
    @Persisted(originProperty: "children") var parent: LinkingObjects<Node>
    
    // Генерация имени из случайных 20 байт в виде hex строки по аналогии с адресом кошельков Ethereum
    func generateRandomName() -> String {
        var randomNum = ""
        var randomBytes = [UInt8](repeating: 0, count: 20)
        let result = SecRandomCopyBytes(kSecRandomDefault, 20, &randomBytes)
        if (result != errSecSuccess) {
            print (result)
        }
        randomNum = randomBytes.map { String(format: "%02hhx", $0)}.joined()
        return randomNum
    }
    
    // Удаление корневого узла
    func delete(at offsets: IndexSet, from nodes: ObservedResults<Node>) {
        for i in offsets {
            if let nodes = nodes.wrappedValue[i].thaw() {
                try? nodes.realm?.write {
                    deleteCascade(parent: nodes, realm: nodes.realm)
                }
            }
            nodes.remove(atOffsets: offsets)
        }
    }
    
    // Каскадное удаление детей узла
    func deleteCascade(parent: Node, realm: Realm?) {
        parent.children.forEach { child in
            deleteCascade(parent: child, realm: realm)
            realm?.delete(child)
        }
    }
}

