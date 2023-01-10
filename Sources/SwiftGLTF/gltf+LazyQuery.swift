//
//  LazyQuery.swift
//  
//
//  Created by Jesse Vander Does on 1/9/23.
//

import Foundation
import GameplayKit
import RealityKit

extension GKBox {
    
    public func expand(box: GKBox) -> GKBox {
        return GKBox(boxMin: min(box.boxMin, self.boxMin), boxMax: max(box.boxMax, self.boxMax))
    }
}

public class GltfNode : NSObject {
    
    public let node: Node
    public let entity: Entity
    
    public init(node: Node, entity: Entity) {
        self.node = node
        self.entity = entity
    }
}

public class LazyQuery : RealityKitGLTFGenerator {
    
    
    public func generateOctree() throws -> GKOctree<GltfNode> {
        var globalBounds = GKBox()
        var bbNodes : [(GltfNode, GKBox)] = []
        
        let rootEntity = Entity()
        let scene = try document.scene.map { try $0.resolve(in: document) } ?? document.scenes.first!

        try scene.nodes
            .map { try $0.resolve(in: document) }
            .map { ($0, try generateEntity(from: $0, lazy: true)) }
            .forEach {
                let entity = $0.1
                rootEntity.addChild(entity)
                
                let visualBB = entity.visualBounds(relativeTo: nil)
                let bb = GKBox(boxMin: visualBB.min, boxMax: visualBB.max)
                globalBounds = globalBounds.expand(box: bb)
                
                bbNodes.append((GltfNode(node: $0.0, entity: entity), bb))
            }

        // Now we know the scenes global bounds
        let octree = GKOctree<GltfNode>(boundingBox: globalBounds,
                                        minimumCellSize: 0.1)

        // Build up our octree
        for bbNode in bbNodes {
            octree.add(bbNode.0, in: bbNode.1)
        }

        return octree
    }
}
