//
//  CloudAnimationView.swift
//  Rainify
//
//  Created by pedrosanz on 23/06/25.
//

import SwiftUI
import SpriteKit

// MARK: - Vista principal
struct CloudAnimationView: View {
    var scene: SKScene {
        let scene = CloudScene7(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), background: .clear)
        scene.size = UIScreen.main.bounds.size
        scene.backgroundColor = .clear
//        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
    }
}

@MainActor
class CloudScenes{
    let bigScene: CloudScene7
    let smallScene: CloudScene7
    
    init() {
        let width = UIScreen.main.bounds.width
        
        // Escena para la vista grande
        bigScene = CloudScene7(
            size: CGSize(width: width, height: 350),
            background: .clear,
            cloudCount: 8
        )
        bigScene.addCloudsIfNeeded()
        
        // Escena para la vista chica
        smallScene = CloudScene7(
            size: CGSize(width: width, height: 70),
            background: .clear,
            cloudCount: 5
        )
        smallScene.addCloudsIfNeeded()
    }
}


// we use this one
struct TransparentCloudsView: UIViewRepresentable {
    var height: CGFloat
    var background: UIColor
    var scene: CloudScene7

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.allowsTransparency = true
        view.backgroundColor = background
        view.isOpaque = false
        
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: height)
        view.presentScene(scene)
        
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}

// MARK: - Escena con nubes
class CloudScene4: SKScene {
    override init(size: CGSize) {
            super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func didMove(to view: SKView) {
        for _ in 0..<7 {
            let cloud = CloudNode(
                imageNamed: "cloud2", // asegúrate de agregar "cloud1.png" a tu proyecto
                size: CGSize(width: 220, height: 80),
                speed: CGFloat.random(in: 20...40)
            )

//            let yPos = CGFloat.random(in: size.height * 0.6 ... size.height * 0.95)
//            let xPos = CGFloat.random(in: -cloud.size.width ... size.width)
            // Posición Y entre 0 y la altura real de la vista
            let yPos = CGFloat.random(in: 0 ... size.height)
            // Posición X aleatoria dentro del ancho de la vista
//            let xPos = CGFloat.random(in: -cloud.size.width ... size.width)
            let xPos = size.width + cloud.size.width
            cloud.position = CGPoint(x: xPos, y: yPos)

            addChild(cloud)
        }
    }
}

// We use this one
class CloudScene7: SKScene {
    private var hasAddedClouds = false
    private let cloudCount: Int?
    private var baseHeight: CGFloat = 300
    
    init(size: CGSize, background: UIColor, cloudCount: Int? = nil) {
        self.baseHeight = size.height
        self.cloudCount = cloudCount
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCloudsIfNeeded() {
        guard !hasAddedClouds else { return }
        
        for _ in 0..<(cloudCount ?? 7) {
            let cloud = CloudNode(
                imageNamed: "cloud2",
                size: CGSize(width: 210, height: 80),
                speed: CGFloat.random(in: 20...40)
            )
            
            let yPos = CGFloat.random(in: baseHeight * 0.1 ... baseHeight * 0.8)
            
            let shouldAppearInside = Bool.random()
            let xPos: CGFloat
            
            if shouldAppearInside {
                xPos = CGFloat.random(in: 0 ... size.width)
            } else {
                let xOffset = CGFloat.random(in: 0 ... size.width * 0.5)
                xPos = size.width + cloud.size.width / 2 + xOffset
            }
            
            cloud.position = CGPoint(x: xPos, y: yPos)
            addChild(cloud)
        }
        hasAddedClouds = true
    }
}

class CloudNode: SKSpriteNode {
    init(imageNamed name: String, size: CGSize, speed: CGFloat) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: size)
        
        self.alpha = 0.0
        self.isHidden = true
        self.zPosition = -1
        
        let wait = SKAction.wait(forDuration: Double.random(in: 0...0.5))
        let show = SKAction.run { [weak self] in self?.isHidden = false }
        let fadeIn = SKAction.fadeAlpha(to: 0.85, duration: 0.4)
        
        let moveAction = moveForever(speed: speed)
        let sequence = SKAction.sequence([wait, show, fadeIn, moveAction])
        self.run(sequence)
        
        let float = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 6, duration: 2),
            SKAction.moveBy(x: 0, y: -6, duration: 2)
        ])
        self.run(SKAction.repeatForever(float))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func moveForever(speed: CGFloat) -> SKAction {
        let distance = UIScreen.main.bounds.width + self.size.width * 2
        let moveLeft = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(speed))
        let reset = SKAction.moveBy(x: distance, y: 0, duration: 0)
        return SKAction.repeatForever(SKAction.sequence([moveLeft, reset]))
    }
}

#Preview {
    @Previewable @State var clouds = CloudScenes()
    
        VStack {
            TransparentCloudsView(
                height: 350,
                background: .clear,
                scene: clouds.bigScene
            )
            .background(Color.red)
            .frame(height: 350)
            .clipped()
            
            TransparentCloudsView(
                height: 70,
                background: .clear,
                scene: clouds.smallScene
            )
            .background(Color.blue)
            .frame(height: 130)
            .clipped()
        }
}
