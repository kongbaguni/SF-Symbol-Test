//
//  View+Extensions.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2022/12/15.
//

import SwiftUI

extension View {
    
    func showShareSheet(with activityItems: [Any]) {
         guard let source = UIApplication.shared.rootViewController else {
            return
        }
        
        
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = source.view
            popoverController.sourceRect = CGRect(x: source.view.bounds.midX,
                                                  y: source.view.bounds.midY,
                                                  width: .zero, height: .zero)
            popoverController.permittedArrowDirections = []
        }
        source.present(activityVC, animated: true)
    }
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
