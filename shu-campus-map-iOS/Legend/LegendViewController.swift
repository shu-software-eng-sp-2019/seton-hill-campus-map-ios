//
//  LegendViewController.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 3/27/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import UIKit
import Pulley
import FirebaseFirestore
import Firebase
import Mapbox.MGLMapCamera

class LegendViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var gripperView: UIView!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    
    @IBOutlet var gripperTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerSectionHeightConstraint: NSLayoutConstraint!
    
    fileprivate var drawerBottomSafeArea: CGFloat = 0.0 {
        didSet {
            self.loadViewIfNeeded()
            
            // We'll configure our UI to respect the safe area. In our small demo app, we just want to adjust the contentInset for the tableview.
            tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: drawerBottomSafeArea, right: 0.0)
        }
    }
    
    private var buildings: [Building] = []
    private var documents: [DocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseApp.configure()
        tableView.dataSource = self
        tableView.delegate = self
        query = buildingsBaseQuery()
        // Do any additional setup after loading the view.
        gripperView.layer.cornerRadius = 2.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ObserveBuildings()
        // stub
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
    
    fileprivate func buildingsBaseQuery() -> Query {
        let firestore: Firestore = Firestore.firestore()
        return firestore.collection("buildings")
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                ObserveBuildings()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    fileprivate func ObserveBuildings() {
        guard let query = query else { return }
        stopObserving()
        
        // Display data from Firestore, part one
        query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Building in
                if let model = Building(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(Building.self) with dictionary \(document.data())")
                }
            }
            self.buildings = models
            self.documents = snapshot.documents
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    deinit {
        listener?.remove()
    }
}

extension LegendViewController: PulleyDrawerViewControllerDelegate {
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return 50 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return 264.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }
    
    // This function is called by Pulley anytime the size, drawer position, etc. changes. It's best to customize your VC UI based on the bottomSafeArea here (if needed). Note: You might also find the `pulleySafeAreaInsets` property on Pulley useful to get Pulley's current safe area insets in a backwards compatible (with iOS < 11) way. If you need this information for use in your layout, you can also access it directly by using `drawerDistanceFromBottom` at any time.
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat)
    {
        // We want to know about the safe area to customize our UI. Our UI customization logic is in the didSet for this variable.
        drawerBottomSafeArea = bottomSafeArea
        
        /*
         Some explanation for what is happening here:
         1. Our drawer UI needs some customization to look 'correct' on devices like the iPhone X, with a bottom safe area inset.
         2. We only need this when it's in the 'collapsed' position, so we'll add some safe area when it's collapsed and remove it when it's not.
         3. These changes are captured in an animation block (when necessary) by Pulley, so these changes will be animated along-side the drawer automatically.
         */
        if drawer.drawerPosition == .collapsed
        {
            headerSectionHeightConstraint.constant = 68.0 + drawerBottomSafeArea
        }
        else
        {
            headerSectionHeightConstraint.constant = 68.0
        }
        
        // Handle tableview scrolling / searchbar editing
        
        tableView.isScrollEnabled = drawer.drawerPosition == .open || drawer.currentDisplayMode == .panel
        
        if drawer.currentDisplayMode == .panel
        {
            topSeparatorView.isHidden = drawer.drawerPosition == .collapsed
            bottomSeparatorView.isHidden = drawer.drawerPosition == .collapsed
        }
        else
        {
            topSeparatorView.isHidden = false
            bottomSeparatorView.isHidden = true
        }
    }
    
    /// This function is called when the current drawer display mode changes. Make UI customizations here.
    func drawerDisplayModeDidChange(drawer: PulleyViewController) {
        print("Drawer: \(drawer.currentDisplayMode)")
        gripperTopConstraint.isActive = drawer.currentDisplayMode == .drawer
    }
}

extension LegendViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProtoCell",
                                                 for: indexPath) as! LegendTableViewCell
        if(self.buildings.count > 0) {
            let building = buildings[indexPath.row]
            cell.populate(building: building)
        }
        return cell
    }
}

extension LegendViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = buildings[indexPath.item]
        let coordinates = selected.coordinates
        let mapVC = self.parent?.children.first as? MapViewController
        let coordsObj = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let camera = MGLMapCamera(lookingAtCenter: coordsObj, altitude: 500, pitch: mapVC!.MapView.camera.pitch, heading: mapVC!.MapView.camera.heading)
        mapVC!.MapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        pulleyViewController?.setDrawerPosition(position: .collapsed, animated: true)
    }
}
