@testable import SwiftGLTF

import XCTest

import GameplayKit

final class GLTFTests: XCTestCase {
    func testExample() throws {
        let url = Bundle.module.url(forResource: "Box", withExtension: "gltf")!
        let data = try Data(contentsOf: url)
        let document = try JSONDecoder().decode(Document.self, from: data)
        dump(document)
    }
    
    func testLazyQuery() throws {
        let url = Bundle.module.url(forResource: "engine", withExtension: "gltf")!
        let gltf = try Container(url: url)
        let realityKit = LazyQuery(container: gltf)
        let octree = try realityKit.generateOctree()
        
        // Given an octree, query for some subsection of the model and generate
        // entities containing full model data and transforms.
    
        /*
        let gltfNodes = octree.elements(in: GKBox())
        
        for gltfNode in gltfNodes {
            let entity = try realityKit.generateEntity(from: gltfNode.node)
        }
         */
    }

}
