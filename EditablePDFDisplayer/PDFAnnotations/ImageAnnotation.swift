//
//  ImageAnnotation.swift
//  EditablePDFDisplayer
//
//  Created by Luigi Scherillo on 28/02/25.
//

import PDFKit

public class ImageAnnotation: PDFAnnotation {
    
    private var _image: UIImage?
    
    public init(imageBounds: CGRect, image: UIImage?) {
        self._image = image
        super.init(bounds: imageBounds, forType: .widget, withProperties: nil)
        self.widgetFieldType = .button
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(with box: PDFDisplayBox, in context: CGContext) {
        guard let cgImage = self._image?.cgImage else {
            return
        }
        let drawingBox = self.page?.bounds(for: box)
        context.draw(cgImage, in: self.bounds.applying(CGAffineTransform(
            translationX: (drawingBox?.origin.x)! * -1.0,
            y: (drawingBox?.origin.y)! * -1.0)))
    }
}
