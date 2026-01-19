import SwiftUI

extension Color {
  func resolvedCGColor(in environment: EnvironmentValues) -> CGColor {
    if #available(iOS 17.0, *) {
      return self.resolve(in: environment).cgColor
    } else {
      let uiColor = UIColor(self)
      let traitCollection = UITraitCollection(
        userInterfaceStyle: environment.colorScheme == .dark ?
          .dark : .light
      )
      return uiColor.resolvedColor(with: traitCollection).cgColor
    }
  }
}

extension GraphicsContext {
  func draw(_ displayNode: Math.DisplayNode, size: CGSize, foregroundColor: Color) {
    var context = self

    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1, y: -1)
    context.translateBy(x: 0, y: displayNode.descent)

    let foregroundColor = foregroundColor.resolvedCGColor(in: environment)

    context.withCGContext { cgContext in
      cgContext.draw(displayNode, foregroundColor: foregroundColor)
    }
  }

  func draw(_ displayNode: Math.DisplayNode, size: CGSize, with shading: GraphicsContext.Shading) {
    var context = self

    context.fill(Path(CGRect(origin: .zero, size: size)), with: shading)
    context.blendMode = .destinationIn

    context.drawLayer {
      $0.draw(displayNode, size: size, foregroundColor: .black)
    }
  }
}
