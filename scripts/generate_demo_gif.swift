import AppKit
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

let canvasWidth = 1100
let canvasHeight = 760
let frameCount = 54
let frameDelay = 0.09
let outputURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("demo.gif")

struct Palette {
    static let bgTop = NSColor(calibratedRed: 0.96, green: 0.98, blue: 1.0, alpha: 1)
    static let bgBottom = NSColor(calibratedRed: 0.89, green: 0.93, blue: 1.0, alpha: 1)
    static let ink = NSColor(calibratedRed: 0.11, green: 0.15, blue: 0.24, alpha: 1)
    static let muted = NSColor(calibratedRed: 0.39, green: 0.46, blue: 0.58, alpha: 1)
    static let blue = NSColor(calibratedRed: 0.30, green: 0.50, blue: 0.98, alpha: 1)
    static let blueSoft = NSColor(calibratedRed: 0.77, green: 0.86, blue: 1.0, alpha: 1)
    static let red = NSColor(calibratedRed: 0.93, green: 0.37, blue: 0.34, alpha: 1)
    static let redSoft = NSColor(calibratedRed: 1.0, green: 0.88, blue: 0.87, alpha: 1)
    static let orange = NSColor(calibratedRed: 0.98, green: 0.67, blue: 0.29, alpha: 1)
    static let orangeSoft = NSColor(calibratedRed: 1.0, green: 0.93, blue: 0.83, alpha: 1)
    static let green = NSColor(calibratedRed: 0.24, green: 0.73, blue: 0.50, alpha: 1)
    static let glass = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 0.88)
    static let border = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 0.55)
    static let phone = NSColor(calibratedRed: 0.12, green: 0.14, blue: 0.18, alpha: 1)
    static let phoneScreen = NSColor(calibratedRed: 0.96, green: 0.97, blue: 0.99, alpha: 1)
}

func clamp(_ value: CGFloat, min lower: CGFloat = 0, max upper: CGFloat = 1) -> CGFloat {
    Swift.max(lower, Swift.min(upper, value))
}

func easeOut(_ t: CGFloat) -> CGFloat {
    1 - pow(1 - clamp(t), 3)
}

func easeInOut(_ t: CGFloat) -> CGFloat {
    let t = clamp(t)
    if t < 0.5 {
        return 4 * t * t * t
    }
    return 1 - pow(-2 * t + 2, 3) / 2
}

func interpolate(_ a: CGFloat, _ b: CGFloat, progress: CGFloat) -> CGFloat {
    a + (b - a) * progress
}

func roundedRect(_ rect: CGRect, radius: CGFloat, fill: NSColor, stroke: NSColor? = nil, lineWidth: CGFloat = 1) {
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    fill.setFill()
    path.fill()
    if let stroke {
        stroke.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
}

func drawText(
    _ text: String,
    rect: CGRect,
    font: NSFont,
    color: NSColor,
    alignment: NSTextAlignment = .left,
    alpha: CGFloat = 1
) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    let attributed = NSAttributedString(
        string: text,
        attributes: [
            .font: font,
            .foregroundColor: color.withAlphaComponent(alpha),
            .paragraphStyle: paragraph
        ]
    )
    attributed.draw(in: rect)
}

func addShadow(color: NSColor, blur: CGFloat, y: CGFloat) {
    let shadow = NSShadow()
    shadow.shadowColor = color
    shadow.shadowBlurRadius = blur
    shadow.shadowOffset = NSSize(width: 0, height: y)
    shadow.set()
}

func drawBackground(size: NSSize) {
    let gradient = NSGradient(starting: Palette.bgTop, ending: Palette.bgBottom)
    gradient?.draw(in: NSRect(origin: .zero, size: size), angle: -90)

    NSGraphicsContext.current?.saveGraphicsState()
    for index in 0..<16 {
        let alpha = 0.035 + CGFloat(index) * 0.004
        Palette.blue.withAlphaComponent(alpha).setStroke()
        let rect = NSRect(
            x: 120 + CGFloat(index) * 24,
            y: 420 - CGFloat(index) * 18,
            width: 320,
            height: 320
        )
        let path = NSBezierPath(roundedRect: rect, xRadius: 48, yRadius: 48)
        path.lineWidth = 1
        path.stroke()
    }
    NSGraphicsContext.current?.restoreGraphicsState()

    for x in stride(from: 44, to: Int(size.width) - 44, by: 24) {
        for y in stride(from: 44, to: Int(size.height) - 44, by: 24) {
            let dotRect = NSRect(x: x, y: y, width: 2, height: 2)
            Palette.ink.withAlphaComponent(0.06).setFill()
            NSBezierPath(ovalIn: dotRect).fill()
        }
    }
}

func drawBadge(text: String, rect: CGRect, fill: NSColor, textColor: NSColor) {
    roundedRect(rect, radius: rect.height / 2, fill: fill)
    drawText(
        text,
        rect: rect.insetBy(dx: 0, dy: 3),
        font: NSFont.systemFont(ofSize: 13, weight: .semibold),
        color: textColor,
        alignment: .center
    )
}

func drawFeatureList() {
    drawText(
        "Manage Popups,\nNot Chaos",
        rect: CGRect(x: 72, y: 500, width: 390, height: 170),
        font: NSFont.systemFont(ofSize: 50, weight: .bold),
        color: Palette.ink
    )

    drawText(
        "Queueing, priority scheduling, custom transitions,\nand a cleaner popup experience for iOS apps.",
        rect: CGRect(x: 76, y: 424, width: 390, height: 90),
        font: NSFont.systemFont(ofSize: 22, weight: .medium),
        color: Palette.muted
    )

    let features = [
        ("Queue", Palette.blueSoft, Palette.blue),
        ("Priority", Palette.redSoft, Palette.red),
        ("ActionSheet", Palette.orangeSoft, Palette.orange)
    ]

    for (index, item) in features.enumerated() {
        let x = 76 + CGFloat(index) * 116
        drawBadge(
            text: item.0,
            rect: CGRect(x: x, y: 360, width: 102, height: 38),
            fill: item.1,
            textColor: item.2
        )
    }

    roundedRect(
        CGRect(x: 76, y: 190, width: 360, height: 128),
        radius: 28,
        fill: NSColor.white.withAlphaComponent(0.58),
        stroke: NSColor.white.withAlphaComponent(0.42),
        lineWidth: 1.2
    )

    drawText(
        "Typical flow",
        rect: CGRect(x: 104, y: 280, width: 180, height: 28),
        font: NSFont.systemFont(ofSize: 17, weight: .semibold),
        color: Palette.ink
    )
    drawText(
        "Low-priority offer enters queue.\nCritical security alert jumps ahead.\nAction sheet appears after dismiss.",
        rect: CGRect(x: 104, y: 216, width: 280, height: 72),
        font: NSFont.systemFont(ofSize: 17, weight: .regular),
        color: Palette.muted
    )
}

func drawPhone(progress: CGFloat, actionSheetProgress: CGFloat, cardPhase: Int, firstCardProgress: CGFloat, criticalProgress: CGFloat) {
    let phoneFrame = CGRect(x: 598, y: 68, width: 380, height: 620)
    let screen = phoneFrame.insetBy(dx: 14, dy: 14)

    NSGraphicsContext.current?.saveGraphicsState()
    addShadow(color: NSColor.black.withAlphaComponent(0.16), blur: 40, y: -10)
    roundedRect(phoneFrame, radius: 48, fill: Palette.phone)
    NSGraphicsContext.current?.restoreGraphicsState()

    roundedRect(screen, radius: 36, fill: Palette.phoneScreen)

    roundedRect(CGRect(x: phoneFrame.midX - 52, y: phoneFrame.maxY - 22, width: 104, height: 12), radius: 6, fill: NSColor.black)

    let screenGradient = NSGradient(colors: [
        NSColor(calibratedRed: 0.98, green: 0.99, blue: 1.0, alpha: 1),
        NSColor(calibratedRed: 0.92, green: 0.96, blue: 1.0, alpha: 1)
    ])
    screenGradient?.draw(in: NSRect(x: screen.minX, y: screen.minY, width: screen.width, height: screen.height), angle: -90)

    drawText(
        "JGAlert",
        rect: CGRect(x: screen.minX + 28, y: screen.maxY - 58, width: 160, height: 24),
        font: NSFont.systemFont(ofSize: 22, weight: .semibold),
        color: Palette.ink
    )
    drawText(
        "10:33",
        rect: CGRect(x: screen.midX - 30, y: screen.maxY - 34, width: 60, height: 20),
        font: NSFont.systemFont(ofSize: 15, weight: .semibold),
        color: Palette.ink,
        alignment: .center
    )

    let buttonRect = CGRect(x: screen.midX - 84, y: screen.midY - 36, width: 168, height: 54)
    NSGraphicsContext.current?.saveGraphicsState()
    addShadow(color: Palette.blue.withAlphaComponent(0.20), blur: 18, y: -4)
    roundedRect(buttonRect, radius: 27, fill: Palette.blue)
    NSGraphicsContext.current?.restoreGraphicsState()
    drawText(
        "Trigger Queue",
        rect: buttonRect.insetBy(dx: 0, dy: 15),
        font: NSFont.systemFont(ofSize: 18, weight: .semibold),
        color: .white,
        alignment: .center
    )

    let queuePanel = CGRect(x: screen.maxX - 130, y: screen.maxY - 188, width: 92, height: 124)
    roundedRect(queuePanel, radius: 22, fill: NSColor.white.withAlphaComponent(0.6), stroke: NSColor.white.withAlphaComponent(0.35))
    drawText(
        "Queue",
        rect: CGRect(x: queuePanel.minX, y: queuePanel.maxY - 34, width: queuePanel.width, height: 24),
        font: NSFont.systemFont(ofSize: 15, weight: .semibold),
        color: Palette.ink,
        alignment: .center
    )

    let queueItems: [(String, NSColor)] = [
        ("LOW", Palette.orange),
        ("HIGH", Palette.blue),
        ("CRIT", Palette.red)
    ]

    for (index, item) in queueItems.enumerated() {
        let y = queuePanel.maxY - 64 - CGFloat(index) * 24
        drawBadge(
            text: item.0,
            rect: CGRect(x: queuePanel.minX + 13, y: y, width: 66, height: 18),
            fill: item.1.withAlphaComponent(0.16),
            textColor: item.1
        )
    }

    if cardPhase <= 1 {
        let pop = easeOut(firstCardProgress)
        let alpha = 0.15 + 0.85 * pop
        let cardWidth: CGFloat = 256
        let cardHeight: CGFloat = 192
        let scale = interpolate(0.88, 1.0, progress: pop)
        let yOffset = interpolate(-30, 0, progress: pop)
        let cardRect = CGRect(
            x: screen.midX - (cardWidth * scale) / 2,
            y: screen.midY + 24 + yOffset,
            width: cardWidth * scale,
            height: cardHeight * scale
        )
        drawAlertCard(
            rect: cardRect,
            title: "Welcome Reward",
            subtitle: "Queued as a normal-priority popup.",
            badgeTitle: "HIGH",
            badgeFill: Palette.blueSoft,
            badgeText: Palette.blue,
            buttonTitle: "Show Details",
            fillAlpha: alpha
        )
    }

    if cardPhase >= 1 {
        let progress = easeInOut(criticalProgress)
        let alpha = progress
        let cardWidth: CGFloat = 270
        let cardHeight: CGFloat = 208
        let scale = interpolate(0.82, 1.0, progress: progress)
        let yOffset = interpolate(-80, 12, progress: progress)
        let cardRect = CGRect(
            x: screen.midX - (cardWidth * scale) / 2,
            y: screen.midY + 12 + yOffset,
            width: cardWidth * scale,
            height: cardHeight * scale
        )
        drawAlertCard(
            rect: cardRect,
            title: "Security Verification",
            subtitle: "Critical alert takes priority over queued popups.",
            badgeTitle: "CRITICAL",
            badgeFill: Palette.redSoft,
            badgeText: Palette.red,
            buttonTitle: "Verify Now",
            fillAlpha: alpha
        )
    }

    if actionSheetProgress > 0 {
        let progress = easeInOut(actionSheetProgress)
        let height: CGFloat = 236
        let y = interpolate(screen.minY - height - 18, screen.minY + 8, progress: progress)
        let sheetRect = CGRect(x: screen.minX + 12, y: y, width: screen.width - 24, height: height)
        drawActionSheet(rect: sheetRect, alpha: progress)
    }
}

func drawAlertCard(
    rect: CGRect,
    title: String,
    subtitle: String,
    badgeTitle: String,
    badgeFill: NSColor,
    badgeText: NSColor,
    buttonTitle: String,
    fillAlpha: CGFloat
) {
    NSGraphicsContext.current?.saveGraphicsState()
    addShadow(color: NSColor.black.withAlphaComponent(0.12 * fillAlpha), blur: 28, y: -6)
    roundedRect(rect, radius: 28, fill: Palette.glass.withAlphaComponent(fillAlpha), stroke: Palette.border.withAlphaComponent(fillAlpha), lineWidth: 1.2)
    NSGraphicsContext.current?.restoreGraphicsState()

    drawBadge(
        text: badgeTitle,
        rect: CGRect(x: rect.minX + 20, y: rect.maxY - 44, width: 88, height: 24),
        fill: badgeFill.withAlphaComponent(fillAlpha),
        textColor: badgeText.withAlphaComponent(fillAlpha)
    )

    drawText(
        title,
        rect: CGRect(x: rect.minX + 20, y: rect.maxY - 86, width: rect.width - 40, height: 28),
        font: NSFont.systemFont(ofSize: 24, weight: .bold),
        color: Palette.ink,
        alpha: fillAlpha
    )

    drawText(
        subtitle,
        rect: CGRect(x: rect.minX + 20, y: rect.maxY - 136, width: rect.width - 40, height: 46),
        font: NSFont.systemFont(ofSize: 16, weight: .medium),
        color: Palette.muted,
        alpha: fillAlpha
    )

    let buttonRect = CGRect(x: rect.minX + 20, y: rect.minY + 20, width: rect.width - 40, height: 44)
    roundedRect(buttonRect, radius: 22, fill: Palette.ink.withAlphaComponent(0.92 * fillAlpha))
    drawText(
        buttonTitle,
        rect: buttonRect.insetBy(dx: 0, dy: 12),
        font: NSFont.systemFont(ofSize: 17, weight: .semibold),
        color: .white,
        alignment: .center,
        alpha: fillAlpha
    )
}

func drawActionSheet(rect: CGRect, alpha: CGFloat) {
    NSGraphicsContext.current?.saveGraphicsState()
    addShadow(color: NSColor.black.withAlphaComponent(0.16 * alpha), blur: 30, y: -8)
    roundedRect(rect, radius: 30, fill: Palette.glass.withAlphaComponent(alpha), stroke: Palette.border.withAlphaComponent(alpha), lineWidth: 1.2)
    NSGraphicsContext.current?.restoreGraphicsState()

    drawText(
        "Action Sheet",
        rect: CGRect(x: rect.minX + 22, y: rect.maxY - 40, width: 160, height: 24),
        font: NSFont.systemFont(ofSize: 20, weight: .bold),
        color: Palette.ink,
        alpha: alpha
    )

    let actions: [(String, NSColor)] = [
        ("Queue another popup", Palette.blue),
        ("Dismiss current one", Palette.green),
        ("Cancel", Palette.red)
    ]

    for (index, item) in actions.enumerated() {
        let rowRect = CGRect(
            x: rect.minX + 18,
            y: rect.maxY - 86 - CGFloat(index) * 52,
            width: rect.width - 36,
            height: 40
        )
        roundedRect(rowRect, radius: 18, fill: item.1.withAlphaComponent(0.10 * alpha))
        drawText(
            item.0,
            rect: CGRect(x: rowRect.minX + 16, y: rowRect.minY + 11, width: rowRect.width - 32, height: 20),
            font: NSFont.systemFont(ofSize: 16, weight: .semibold),
            color: item.1,
            alpha: alpha
        )
    }
}

func makeFrame(index: Int) -> CGImage? {
    let image = NSImage(size: NSSize(width: canvasWidth, height: canvasHeight))
    image.lockFocus()

    drawBackground(size: image.size)
    drawFeatureList()

    let firstPhase = clamp(CGFloat(index) / 11)
    let criticalPhase = clamp((CGFloat(index) - 16) / 12)
    let actionSheetPhase = clamp((CGFloat(index) - 34) / 12)

    let cardPhase: Int
    if index < 16 {
        cardPhase = 0
    } else if index < 34 {
        cardPhase = 1
    } else {
        cardPhase = 2
    }

    drawPhone(
        progress: firstPhase,
        actionSheetProgress: actionSheetPhase,
        cardPhase: cardPhase,
        firstCardProgress: firstPhase,
        criticalProgress: criticalPhase
    )

    drawText(
        "Priority-aware popup scheduling for iOS",
        rect: CGRect(x: 74, y: 112, width: 340, height: 24),
        font: NSFont.systemFont(ofSize: 16, weight: .medium),
        color: Palette.muted
    )

    drawBadge(
        text: "JGAlert",
        rect: CGRect(x: 74, y: 74, width: 90, height: 30),
        fill: Palette.ink.withAlphaComponent(0.92),
        textColor: .white
    )

    image.unlockFocus()

    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let cgImage = bitmap.cgImage else {
        return nil
    }
    return cgImage
}

let frameProperties = [
    kCGImagePropertyGIFDictionary: [
        kCGImagePropertyGIFDelayTime: frameDelay
    ]
] as CFDictionary

let gifProperties = [
    kCGImagePropertyGIFDictionary: [
        kCGImagePropertyGIFLoopCount: 0
    ]
] as CFDictionary

guard let destination = CGImageDestinationCreateWithURL(
    outputURL as CFURL,
    UTType.gif.identifier as CFString,
    frameCount,
    nil
) else {
    fatalError("Unable to create GIF destination")
}

CGImageDestinationSetProperties(destination, gifProperties)

for index in 0..<frameCount {
    if let frame = makeFrame(index: index) {
        CGImageDestinationAddImage(destination, frame, frameProperties)
    }
}

if !CGImageDestinationFinalize(destination) {
    fatalError("Failed to finalize GIF")
}

print("Generated \(outputURL.path)")
