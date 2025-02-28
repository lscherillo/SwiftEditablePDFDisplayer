//
//  EditablePDFViewDisplayer.swift
//  EditablePDFDisplayer
//
//  Created by Luigi Scherillo on 28/02/25.
//

import UIKit
import PDFKit

class EditablePDFViewDisplayer: UIView {
    
    private var pdfView: PDFView
    
    let pdfDocumentUrl: URL
    weak var delegate: EditablePDFDisplayerDelegate?
    
    init(pdfDocumentUrl: URL) {
        self.pdfDocumentUrl = pdfDocumentUrl
        self.pdfView = PDFView()
        super.init(frame: .zero)
        setupPDFView()
        subscribeToHits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPDFView() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if let document = PDFDocument(url: pdfDocumentUrl) {
            pdfView.document = document
        }
    }

    private func subscribeToHits() {
        NotificationCenter.default.addObserver(forName: .PDFViewAnnotationHit, object: nil, queue: nil) { notification in
            if let annotation = notification.userInfo?["PDFAnnotationHit"] as? PDFAnnotation,
               let annotationName = annotation.fieldName {
                self.delegate?.didTapOnAnnotation(named: annotationName)
                print(annotation.debugDescription)
            }
        }
    }
    
    public func resetPdfToInitialState() {
        if let document = PDFDocument(url: pdfDocumentUrl) {
            pdfView.document = document
        }
    }
    
    public func getValue(for field: String) -> String {
        guard let pdfDocument = pdfView.document else { return "" }
        
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                for annotation in page.annotations {
                    if annotation.fieldName == field {
                        return annotation.widgetStringValue ?? ""
                    }
                }
            }
        }
        return ""
    }
    
    /// Imposta un valore per un campo modulo specifico
    public func setValue(_ value: String, for field: String) {
        guard let pdfDocument = pdfView.document else { return }
        
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                for annotation in page.annotations {
                    if annotation.fieldName == field {
                        annotation.widgetStringValue = value
                        return
                    }
                }
            }
        }
    }
    
    /// Restituisce tutte le annotazioni con i loro valori
    public func getAllAnnotationsWithValues() -> [AnnotationData] {
        guard let pdfDocument = pdfView.document else { return [] }
        var annotationsList: [AnnotationData] = []
        
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                for annotation in page.annotations {
                    if let name = annotation.fieldName {
                        let value = annotation.widgetStringValue ?? ""
                        annotationsList.append(AnnotationData(name: name, value: value))
                    }
                }
            }
        }
        return annotationsList
    }
    
    /// Restituisce un array con i nomi di tutte le annotazioni
    public func getAnnotationsNames() -> [String] {
        guard let pdfDocument = pdfView.document else { return [] }
        var listOfFieldNames: [String] = []
        
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                for annotation in page.annotations {
                    if let name = annotation.fieldName {
                        listOfFieldNames.append(name)
                    }
                }
            }
        }
        return listOfFieldNames
    }

    private func addImage(in annotation: PDFAnnotation, page: PDFPage, image: UIImage) {
        let annotationFrame = annotation.bounds
        let myAnnotation = ImageAnnotation(imageBounds: annotationFrame, image: image)
        page.removeAnnotation(annotation)
        page.addAnnotation(myAnnotation)
    }
    
}
