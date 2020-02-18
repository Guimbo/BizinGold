//
//  GameScene.swift
//  BizinGold
//
//  Created by Guilherme Araujo on 12/02/20.
//  Copyright © 2020 Guilherme Araujo. All rights reserved.
//

import SpriteKit
import GameplayKit

enum pieceColor: String {
    case blue
    case green
}

class GameScene: SKScene {

    private var spinnyNode : SKShapeNode?
    var board: SKTileMapNode!
    var bluePoints: [SKSpriteNode]!
    var greenPoints: [SKSpriteNode]!
    var selectedPin = SKSpriteNode()
    weak var viewController: GameViewController?
    
    var pieceMatrix = (0,0)
    var touchCount = 0
    var totalMoves = -1
    
    var possibleBlueMoves: [(Int, Int)] = []
    var possibleGreenMoves: [(Int, Int)] = []
    
    let possibleOrientations = [(1,1), (1,-1), (0,2), (0,-2), (-1,1),(-1,-1)]
    let piecesAround = [(0,1), (0,-1), (1,0), (-1,0)]
    var count: [SKNode] = []
    
    var blueInitialPosition: [CGPoint] = []
    var greenInitialPosition: [CGPoint] = []
    
    var player: String = ""
    var username: String = ""
    var originalPin: SKTexture?

   // var playerTurn: pieceColor = .blue
    
    var previousMove: Coordinate!
    
    
    
    
    override func didMove(to view: SKView) {
        board = childNode(withName: "bizingoBoard") as? SKTileMapNode
        bluePoints = board.children
            .filter { ($0.name == "isBlue" || $0.name == "blueCaptain") }
            .map { $0 as! SKSpriteNode }
        
        greenPoints = board.children
            .filter { ($0.name == "isGreen" || $0.name == "greenCaptain") }
            .map { $0 as! SKSpriteNode }
        
        
        blueInitialPosition = bluePoints.map { $0.position }
        greenInitialPosition = greenPoints.map { $0.position }
        
        setupGameBoard()
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    private func setupGameBoard() {
        let columns = board.numberOfColumns
        let rows = board.numberOfRows
        
        for col in 0..<columns {
            for row in 0..<rows {
                let tile = board.tileGroup(atColumn: col, row: row)
                if let tileGroupName = tile?.name,
                    tileGroupName == "Up Tiles" {
                    let tileDefinition = board.tileDefinition(atColumn: col, row: row)
                    tileDefinition?.userData = NSMutableDictionary()
                    tileDefinition?.userData?.setValue(true, forKey: "boardup")
                    possibleBlueMoves.append((col, row))
                }
                if let tileGroupName = tile?.name,
                    tileGroupName == "Down Tiles" {
                    let tileDefinition = board.tileDefinition(atColumn: col, row: row)
                    tileDefinition?.userData = NSMutableDictionary()
                    tileDefinition?.userData?.setValue(true, forKey: "boardDown")
                    possibleGreenMoves.append((col,row))
                }
            }
        }
    }
    
    private func movePiece(atPos pos: CGPoint) {
        let boardPos = self.convert(pos, to: board)
        let col = board.tileColumnIndex(fromPosition: boardPos)
        let row = board.tileRowIndex(fromPosition: boardPos)
        let tileNode = board.nodes(at: boardPos).first
        let clickTexture: SKTexture = SKTexture.init(imageNamed: "selectedPin")
        
        
            if touchCount < 1 {
                if checkIfIsPiece([tileNode ?? SKNode()]) {
                    
                    selectedPin = tileNode as! SKSpriteNode
                    selectedPin.removeAction(forKey: "drop")
                    originalPin = self.returnTextureFrom(selectedPin)
                    selectedPin.run(SKAction.setTexture(clickTexture), withKey: "pickup")
//                    selectedPin.run(SKAction.scale(to: 10, duration: 0.25), withKey: "pickup")
                    pieceMatrix = (row,col)
                    touchCount += 1
                }
            } else {
                movePieceTo(piece: selectedPin, pieceMatrix: pieceMatrix, col: col, row: row)
                selectedPin.removeAction(forKey: "pickup")
                selectedPin.run(SKAction.setTexture(originalPin!), withKey: "drop")
                touchCount += 1

            }
            
            if touchCount == 2 {
                touchCount = 0
                selectedPin = SKSpriteNode()
            }
        }

    
    private func checkIfIsPiece(_ nodes: [SKNode]) -> Bool {
        let pieceCount = nodes.filter { $0.userData?["isPiece"] != nil }.count
        return pieceCount > 0 ? true : false
    }
    
    func returnTextureFrom(_ node: SKSpriteNode) -> SKTexture{
        var texture: SKTexture?
        if node.name == "isBlue"{
            texture = SKTexture.init(imageNamed: "pin1")
        }
        
        else if node.name == "blueCaptain" {
            texture = SKTexture.init(imageNamed: "captain1")
        }
        
        else if node.name == "isGreen" {
            texture = SKTexture.init(imageNamed: "pin2")
        }
        
        else if node.name == "greenCaptain"{
            texture = SKTexture.init(imageNamed: "captain2")
        }
        return texture!
    }
    
    
    
    //MARK: A FUNÇÃO
    func movePieceTo(piece: SKSpriteNode,pieceMatrix: (Int, Int), col: Int, row: Int) {
        let boardTileCenter = board.centerOfTile(atColumn: col, row: row)
        let offset: CGFloat = -20
        var position = CGPoint(x: boardTileCenter.x, y: boardTileCenter.y)
        
        //corrigindo centro da peça
        if piece.name == "isBlue" || piece.name == "blueCaptain" {
            position.y += offset
        } else {
            position.y -= offset
        }
        
        //impedindo sobreposição de peça
        
        let rowOrientation = pieceMatrix.0 - row
        let colOrientation = pieceMatrix.1 - col
        
        let tuple = (rowOrientation, colOrientation)
        
        possibleOrientations.forEach { (orientation) in
            if orientation.0 == tuple.0 && orientation.1 == tuple.1 {
                if board.nodes(at: boardTileCenter).count == 0 {
                    piece.run(SKAction.move(to: position, duration: 0.5)) {
                        
                    }
                }
            }
        }
    }
  
   
    
    func touchUp(atPoint pos : CGPoint) {
        movePiece(atPos: pos)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
