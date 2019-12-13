//
//  HomeViewController.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 11/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import MapKit
class HomeViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapViewNotes: MKMapView!
    private let locationManager : CLLocationManager? = nil
    // data
    var selectedNote: DBNote?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        self.mapViewNotes.showsUserLocation = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNotesInMap()
        setFakeUserPosition()
    }
    
    func configureNotesInMap() {
        var annotations = [MKAnnotation]()
        //            for note in NotesManager.sharedInstance.notes {
        //                let annotation = NoteAnnotation(currentNote: note)
        //                annotations.append(annotation)
        //            }
        self.mapViewNotes.removeAnnotations(self.mapViewNotes.annotations)
        self.mapViewNotes.addAnnotations(annotations)
    }
    
    func setFakeUserPosition() {
        let visibleRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.57983, longitude: -52.68997), latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapViewNotes.setRegion(self.mapViewNotes.regionThatFits(visibleRegion), animated: true)
    }
    
    // MARK: Search bar delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        print ("search bar text : %@", self.searchBar.text!)
    }
    // MARK: Filter Notes
    func filterNotesWithString(filterString: String!) -> [DBNote]? {
        
        return nil
    }
    // MARK: - MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //  let visibleRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let visibleRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.57983, longitude: -52.68997), latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapViewNotes.setRegion(self.mapViewNotes.regionThatFits(visibleRegion), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapViewNotes.dequeueReusableAnnotationView(withIdentifier: Constants.Storyboard.kNoteAnnotationName)
        
        if annotationView == nil {
            // annotationView = NotesAnnotationView(annotation: annotation, reuseIdentifier: Constants.Storyboard.kNoteAnnotationName)
            // (annotationView as! NotesAnnotationView).noteDetailDelegate = self
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    
    // MARK: - Selecting a note and seguing to details - delegate, havent implemented yet
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func detailsRequestedForPerson(note: DBNote) {
        self.selectedNote = note
        //  self.performSegue(withIdentifier: "selectedNote", sender: nil)
    }
}
