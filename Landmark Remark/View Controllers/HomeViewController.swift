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
    private let locationManager : CLLocationManager? = nil
    // data
    var selectedNote: DBNote?
    var notesArray: [DBNote]?
    let notesRef = Database.database().reference(withPath: "notes")
    let usersRef = Database.database().reference(withPath: "users")
    var databaseHandle:DatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        self.mapViewNotes.showsUserLocation = true
        //self.createNotesDummy()
        self.getAllNotes()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getAllNotes(){
        self.notesArray = [DBNote]()
        //retrieve the notes and listen for changes
               self.notesRef.observe(.childAdded) { (snapshot) in
                   //code to execute when child is added in notes
                   //take a values from notes and add into custom notes annotation arrays
                   let note = DBNote.init(snapshot: snapshot)
                   self.notesArray?.append(note!)
               }
        if self.notesArray!.count > 0{
         //   self.configureNotesInMap()
        }
    }
    
    func createNotesDummy()  {
        
       // var ref: DatabaseReference!
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        let name = Auth.auth().currentUser?.displayName
        
        let lats = [-33.8867884,-33.886645,-33.886625,-33.884555,-33.884921,-33.886132]
        let lons = [151.2099372,151.209187,151.208881,151.211181,151.215827,151.209347]
        
       
        self.notesRef.childByAutoId().setValue(["note_text":"test note","addedByUser":name ?? "Anonymous", "location":"test location", "uid": userID,"is_public":true,"lat": -33.884921, "lon":151.215827 ]) {  (error, dbreference)  in
            if error != nil
            {
                
            }
            else{
                
            }
        
    }
    }

    func configureNotesInMap() {
        var annotations = [MKAnnotation]()
        for note in self.notesArray! {
            let annotation = NoteAnnotation(currentNote: note)
            annotations.append(annotation)
        }
            
            self.mapViewNotes.removeAnnotations(self.mapViewNotes.annotations)
            self.mapViewNotes.addAnnotations(annotations)
            
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
                annotationView = NotesAnnotationView(annotation: annotation, reuseIdentifier: Constants.Storyboard.kNoteAnnotationName)
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
        func logouotAndTranisitionToInitialScreen()  {
            //logout user
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
                
            }
            //set map screen as root view controller, purge login, signup, home screens from memory
            let homeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UINavigationController
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        }
        @IBAction func btnLogout_tapped(_ sender: Any) {
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
