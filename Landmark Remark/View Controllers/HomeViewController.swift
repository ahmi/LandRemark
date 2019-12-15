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
    var notesArray: [DBNote]  = []
    let notesRef = Database.database().reference(withPath: "notes") // URL to notes in db
    var databaseHandle:DatabaseHandle?
    var notesFilteredArray: [DBNote]  = []
    var isShowingFilteredNotes = false
    var current_location:CLLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLocationManager()
        self.getAllNotes()
    }
    // MARK:- Setup Componenets
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
        if let coor = self.mapViewNotes.userLocation.location?.coordinate{
            self.mapViewNotes.setCenter(coor, animated: true)
        }
    }
    
    func getAllNotes(){
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
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
                strongSelf.configureAllNotesInMap()
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
                    strongSelf.configureAllNotesInMap()
                }
            } else {
                // we are ignoring this child since it is pre-existing data
            }
        }
    }
    
    func configureAllNotesInMap() {
        //hide activity indicator
        self.view.activityStopAnimating()
        //Check if filtering then show filtered notes
        //otherwise show all notes
        var notesToShow = [DBNote]()
        if isShowingFilteredNotes{
            notesToShow = self.notesFilteredArray
        }else{
            notesToShow = self.notesArray
        }
        var annotations = [MKAnnotation]()
        for note in notesToShow {
            let annotation = NoteAnnotation(currentNote: note)
            annotations.append(annotation)
        }
        self.mapViewNotes.removeAnnotations(self.mapViewNotes.annotations)
        self.mapViewNotes.addAnnotations(annotations)
        mapViewNotes.showAnnotations(annotations, animated: true)
    }
    
    // MARK: - MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Zoom to 1000 meters of user's current location
        let visibleRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
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
    
    // MARK: - location manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapViewNotes.showsUserLocation = true
        }
        if(status == CLAuthorizationStatus.denied) {
            Utilities.showAlertMessage(vc: self, titleStr: "Error", messageStr: "Please check settings for location permissions")
        }
    }
    //Called everytime user's location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.mapViewNotes.mapType = MKMapType.standard
        //Zoom to 1000 meters of user's current location
        let visibleRegion = MKCoordinateRegion(center: locValue, latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapViewNotes.setRegion(self.mapViewNotes.regionThatFits(visibleRegion), animated: true)
        //Save updated location, to use later when user add notes
        current_location = locations[0] as CLLocation
    }
    // MARK: Search bar delegates
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isShowingFilteredNotes = false
        self.searchBar.resignFirstResponder()
        self.configureAllNotesInMap()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
        // print ("search bar text : %@", self.searchBar.text!)
        let searchString = searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (searchString.count > 0){
            self.searchNoteWithText(searchterm: searchString)
        } else {
            Utilities.showAlertMessage(vc: self, titleStr: "Error", messageStr: "Invalid search")
        }
    }
    // MARK: - Filter Notes
    func searchNoteWithText(searchterm: String) {
        //re-initalise filtered notes array
        self.notesFilteredArray = [DBNote]()
        notesFilteredArray = self.notesArray.filter { (note) -> Bool in
            //case insensitive search query
            if note.addedByUser.localizedCaseInsensitiveContains(searchterm) || note.note_text.localizedCaseInsensitiveContains(searchterm) {
                return true
            }
            return false
        }
        //check if filtered array has notes reload map annotation
        if (self.notesFilteredArray.count > 0){
            self.isShowingFilteredNotes  = true
            self.configureAllNotesInMap()
        }
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
    
    @IBAction func btnCreateNote_tapped(_ sender: Any) {
        //check if we have current location instance,
        //because it is required to create a note
        // if self.mapViewNotes.userLocation.location{
        self.createNoteAtCurrentLocation()
        //}
    }
    
    @IBAction func btnLogout_tapped(_ sender: Any) {
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
    //MARK:- Helper
    //present nav controller to create a note
    //pass location data to create note screen to use in creating note
    func createNoteAtCurrentLocation() {
        guard let createVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.kCreateNoteVC) as? CreateNoteViewController else {
            return
        }
        createVC.current_location = self.current_location
        guard let createNoteNav = storyboard?.instantiateViewController(identifier: Constants.Storyboard.createNoteViewController) as? UINavigationController else {return}
        self.navigationController?.present(createNoteNav, animated: true, completion: nil)
    }
}
