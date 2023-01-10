@testable import SwiftGLTF

import XCTest

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
        print("whoop")
    }

}
