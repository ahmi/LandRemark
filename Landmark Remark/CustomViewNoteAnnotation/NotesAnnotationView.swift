//
//  NotesAnnotationView.swift
//  TestNotesApp
//
//  Created by Ahmad Waqas on 6/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import MapKit
private let knoteMapPinImage = UIImage(named: "mapPin")!
private let knoteMapAnimationTime = 0.300
class NotesAnnotationView: MKAnnotationView {
   weak var customCalloutView: NoteDetailMapView?

    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    // MARK: - life cycle
     
     override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
         super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
         self.canShowCallout = false
         self.image = knoteMapPinImage
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.canShowCallout = false // This is important: Don't show default callout.
         self.image = knoteMapPinImage
     }
    // MARK: - callout showing and hiding
    // Important: the selected state of the annotation view controls when the
    // view must be shown or not. We should show it when selected and hide it
    // when de-selected.
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadNoteDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
            
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: knoteMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: knoteMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    func loadNoteDetailMapView() -> NoteDetailMapView? {
         if let views = Bundle.main.loadNibNamed("NoteDetailMapView", owner: self, options: nil) as? [NoteDetailMapView], views.count > 0 {
             let noteDetailMapView = views.first!
            // personDetailMapView.delegate = self.personDetailDelegate
             if let noteAnnotation = annotation as? NoteAnnotation {
                 let note = noteAnnotation.note
                 noteDetailMapView.configureWithPerson(currentNote: note)
             }
             return noteDetailMapView
         }
         return nil
     }
    override func prepareForReuse() {
           super.prepareForReuse()
           self.customCalloutView?.removeFromSuperview()
       }
       
       // MARK: - Detecting and reaction to taps on custom callout.
       
       override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
           // if super passed hit test, return the result
           if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
           else { // test in our custom callout.
               if customCalloutView != nil {
                   return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
               } else { return nil }
           }
       }

}
