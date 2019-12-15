//
//  HomeViewController.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 11/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapViewNotes: MKMapView!
    private var locationManager = CLLocationManager()
    // data
    var initialDataLoaded = false
    var selectedNote: DBNote?
    var notesArray: [DBNote]  = []
    let notesRef = Database.database().reference(withPath: "notes")
    let usersRef = Database.database().reference(withPath: "users")
    var databaseHandle:DatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLocationManager()
        self.getAllNotes()
    }
    // MARK:- Setup UI and Data
    func setUpLocationManager(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                       self.mapViewNotes.showsUserLocation = true
                   } else {
            self.locationManager.requestWhenInUseAuthorization()
                   }
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.mapViewNotes.showsUserLocation = true
        self.mapViewNotes.delegate = self
        self.searchBar.delegate = self
    }
    
    func getAllNotes(){
        self.notesArray = [DBNote]()
        //retrieve the notes and listen for changes
        
        self.notesRef.observeSingleEvent(of: .value) { [weak self] (snapShot) in
            guard let strongSelf = self else { return }
            if !snapShot.exists() { return }
            guard let snaps = snapShot.value as? [String: Any] else {
                return
            }
            for snap in snaps {
                if let value = snap.value as? [String: Any] {
                    if let note = DBNote.init(dict: value, key: snap.key) {
                        strongSelf.notesArray.append(note)
                    }
                }
            }
            if strongSelf.notesArray.count > 0 {
                strongSelf.configureNotesInMap()
            }
            strongSelf.initialDataLoaded = true
        }
        self.notesRef.observe(.childAdded) { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            if (strongSelf.initialDataLoaded) {
                //code to execute when child is added in notes
                //take a values from notes and add into custom notes annotation arrays
                if let note = DBNote.init(snapshot: snapshot) {
                    strongSelf.notesArray.append(note)
                    strongSelf.configureNotesInMap()
                }
            } else {
                // we are ignoring this child since it is pre-existing data
            }
        }
    }
    
    func configureNotesInMap() {
        var annotations = [MKAnnotation]()
        for note in self.notesArray {
            let annotation = NoteAnnotation(currentNote: note)
            annotations.append(annotation)
        }
        self.mapViewNotes.removeAnnotations(self.mapViewNotes.annotations)
        self.mapViewNotes.addAnnotations(annotations)
        mapViewNotes.showAnnotations(annotations, animated: true)
    }
    // MARK: - location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapViewNotes.showsUserLocation = true
        }
    }
    // MARK: Search bar delegates
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
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
        //Reuse annotation view just like tableview
        var annotationView = mapViewNotes.dequeueReusableAnnotationView(withIdentifier: Constants.Storyboard.kNoteAnnotationName)
        
        if annotationView == nil {
            annotationView = NotesAnnotationView(annotation: annotation, reuseIdentifier: Constants.Storyboard.kNoteAnnotationName)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    // MARK: - Button Actions
    
    func logouotAndTranisitionToInitialScreen()  {
        //logout user
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            
        }
        //set initial screen as root view controller, purge login, signup, home screens from memory
        let initialVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.initialViewController) as? UINavigationController
        view.window?.rootViewController = initialVC
        view.window?.makeKeyAndVisible()
    }
    //present nav controller to create a note
    //pass location data to create note screen to use in creating note
    func createNoteAtCurrentLocation() {
        guard let createNoteVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.createNoteViewController) as? UINavigationController else {return}
        self.navigationController?.present(createNoteVC, animated: true, completion: nil)
    }
    @IBAction func btnLogout_tapped(_ sender: Any) {
        self.createNoteAtCurrentLocation()
        return
        //create confirmation alert 
        let alert = UIAlertController(title: "Confirm Logout?", message: "This will log you out", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            switch action.style{
                case .default:
                    self.logouotAndTranisitionToInitialScreen()
                
                case .cancel:
                    print("cancel")
                
                
                case .destructive:
                    print("destructive")
                @unknown default:
                    print("unknown default")
            }}))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
