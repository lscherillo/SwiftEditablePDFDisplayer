//
//  PDFExporter.swift
//  EditablePDFDisplayer
//
//  Created by Luigi Scherillo on 28/02/25.
//
import PDFKit

struct PDFExporter {

    static public func save(document: PDFDocument, to url: URL) throws {
        if !document.write(to: url) {
            throw NSError(domain: "PDFSaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save PDF at \(url.path)"])
        }
    }
    
    static public func flattenPDF(document: PDFDocument) -> PDFDocument? {
        let newPDFData = NSMutableData()
        
        guard let consumer = CGDataConsumer(data: newPDFData as CFMutableData) else { return nil }
        
        var mediaBox = CGRect.zero
        if let firstPage = document.page(at: 0) {
            mediaBox = firstPage.bounds(for: .mediaBox)
        }
        
        guard let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else { return nil }
        
        for i in 0..<document.pageCount {
            guard let page = document.page(at: i) else { continue }
            mediaBox = page.bounds(for: .mediaBox)
            context.beginPage(mediaBox: &mediaBox)
            page.draw(with: .mediaBox, to: context)
            
            context.endPage()
        }
        
        context.closePDF()
        
        return PDFDocument(data: newPDFData as Data)
    }

}
