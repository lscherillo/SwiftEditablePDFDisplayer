//
//  EditablePDFDisplayerDelegate.swift
//  EditablePDFDisplayer
//
//  Created by Luigi Scherillo on 28/02/25.
//
import PDFKit

protocol EditablePDFDisplayerDelegate: AnyObject {
    func editablePDFDisplayerDidFinishEditing(_ editablePDFDisplayer: EditablePDFViewDisplayer)
    func didTapOnAnnotation(named annotationName: String)
}
