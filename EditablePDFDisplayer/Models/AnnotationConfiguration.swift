//
//  AnnotationConfiguration.swift
//  EditablePDFDisplayer
//
//  Created by Luigi Scherillo on 28/02/25.
//

struct AnnotationConfiguration {
    enum AnnotationKind {
        case image
        case text
    }
    
    let style: AnnotationStyle
    let initialValue: String
    let annotationKind: AnnotationKind
}
