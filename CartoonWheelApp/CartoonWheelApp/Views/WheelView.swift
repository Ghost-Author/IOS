//
//  WheelView.swift
//  CartoonWheelApp
//
//  Created by liupeng on 2025/11/20.
//

import UIKit
import AVFoundation

class WheelView: UIView {
    
    var options: [WheelOption] = [] { didSet { setNeedsDisplay() } }
    
    private var audioPlayer: AVAudioPlayer?
    private var displayLink: CADisplayLink?
    private var rotationAngle: CGFloat = 0
    private var spinning = false
    private var lastTickIndex: Int?
    
    private var spinStartTime: CFTimeInterval = 0
    private var spinDuration: TimeInterval = 0
    private var startAngle: CGFloat = 0
    private var endAngle: CGFloat = 0
    
    // 渐变颜色
    private var gradientColors: [UIColor] {
        options.map { UIColor(hex: $0.colorHex) }
    }
    
    override func draw(_ rect: CGRect) {
        guard options.count > 0 else { return }
        let ctx = UIGraphicsGetCurrentContext()!
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let anglePerSlice = CGFloat.pi * 2 / CGFloat(options.count)
        
        for (i, option) in options.enumerated() {
            let start = CGFloat(i) * anglePerSlice + rotationAngle
            let end = start + anglePerSlice
            
            // 扇片路径
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            
            ctx.saveGState()
            path.addClip()
            
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: [gradientColors[i % gradientColors.count].cgColor,
                                               gradientColors[(i+1) % gradientColors.count].cgColor] as CFArray,
                                      locations: [0,1])!
            ctx.drawLinearGradient(gradient,
                                   start: CGPoint(x: 0, y: 0),
                                   end: CGPoint(x: bounds.width, y: bounds.height),
                                   options: [])
            ctx.restoreGState()
            
            // 扇片边框
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setLineWidth(2)
            ctx.addPath(path.cgPath)
            ctx.strokePath()
            
            // 绘制文字
            let midAngle = (start + end) / 2
            let textPoint = CGPoint(
                x: center.x + cos(midAngle) * radius * 0.6 - 10,
                y: center.y + sin(midAngle) * radius * 0.6 - 10
            )
            let attr: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.white
            ]
            NSString(string: option.title).draw(at: textPoint, withAttributes: attr)
        }
        
        // 中心按钮
        let centerCircle = UIBezierPath(ovalIn: CGRect(x: center.x-40, y: center.y-40, width: 80, height: 80))
        UIColor.orange.setFill()
        centerCircle.fill()
        
        let title = "GO"
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.white
        ]
        let size = NSString(string: title).size(withAttributes: attr)
        NSString(string: title).draw(at: CGPoint(x: center.x-size.width/2, y: center.y-size.height/2), withAttributes: attr)
    }
    
    func spin(duration: TimeInterval = 4) {
        guard !spinning else { return }
        spinning = true
        
        spinStartTime = CACurrentMediaTime()
        spinDuration = duration
        startAngle = rotationAngle
        endAngle = rotationAngle + CGFloat.pi*4 + CGFloat.random(in: 0...(CGFloat.pi*2))
        lastTickIndex = nil
        
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateSpin))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    @objc private func updateSpin() {
        let now = CACurrentMediaTime()
        let elapsed = now - spinStartTime
        if elapsed >= spinDuration {
            rotationAngle = endAngle.truncatingRemainder(dividingBy: 2*CGFloat.pi)
            spinning = false
            displayLink?.invalidate()
            displayLink = nil
            HapticManager.shared.success()
        } else {
            let t = CGFloat(elapsed / spinDuration)
            rotationAngle = startAngle + (endAngle - startAngle) * easeOutCubic(t)
            playTick()
        }
        setNeedsDisplay()
    }
    
    private func playTick() {
        guard options.count > 0 else { return }
        let tickIndex = Int(rotationAngle / (2*CGFloat.pi) * CGFloat(options.count))
        if tickIndex != lastTickIndex {
            lastTickIndex = tickIndex
            HapticManager.shared.tick()
            if let url = Bundle.main.url(forResource: "tick", withExtension: "wav") {
                audioPlayer = try? AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            }
        }
    }
    
    private func easeOutCubic(_ t: CGFloat) -> CGFloat {
        return 1 - pow(1 - t, 3)
    }
}
