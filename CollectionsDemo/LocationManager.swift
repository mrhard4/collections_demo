//
//  LocationManager.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 20.10.2020.
//

import UIKit
import CoreLocation

protocol LocationProvider {
    var currentLocation: Location? { get }
}

protocol LocationManager {
    var status: LocationManagerStatus { get }

    func requestPermissions()

    func add(listener: LocationManagerStatusChangeListener)
    func remove(listener: LocationManagerStatusChangeListener)
}

protocol LocationManagerStatusChangeListener: class {
    func statusChange(_ locationManager: LocationManager)
}

struct Location: Equatable {
    let latitude: Double
    let longitude: Double
}

enum LocationManagerStatus {
    case unknown
    case globalDisabled
    case denied
    case allowed
}

final class LocationManagerImpl: NSObject, LocationProvider, LocationManager {
    private(set) var currentLocation: Location?

    private(set) var status: LocationManagerStatus = .unknown

    private let locationManager = CLLocationManager()

    private var listeners = NSHashTable<AnyObject>.weakObjects()

    private var isLocationUpdatingStarted = false

    private var observerWillResignActiveNotification: NSObjectProtocol?
    private var observerDidBecomeActiveNotification: NSObjectProtocol?

    override init() {
        super.init()

        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.delegate = self

        self.updateStatus()
        self.updateCurrentLocation(self.locationManager.location)

        self.observerWillResignActiveNotification = NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification,
                object: nil,
                queue: nil) { [weak self] _ in
            self?.locationManager.delegate = nil
        }
        self.observerDidBecomeActiveNotification = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                object: nil,
                queue: nil) { [weak self] _ in
            self?.locationManager.delegate = self
            self?.updateStatusAndNotifyIfNeeded()
        }
    }

    deinit {
        self.observerWillResignActiveNotification.map { NotificationCenter.default.removeObserver($0) }
        self.observerDidBecomeActiveNotification.map { NotificationCenter.default.removeObserver($0) }
    }

    func requestPermissions() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    func add(listener: LocationManagerStatusChangeListener) {
        self.listeners.add(listener)
    }

    func remove(listener: LocationManagerStatusChangeListener) {
        self.listeners.remove(listener)
    }
}

extension LocationManagerImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.updateCurrentLocation(locations.last)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.updateStatusAndNotifyIfNeeded()
    }
}

private extension LocationManagerImpl {
    func updateStatusAndNotifyIfNeeded() {
        let currentStatus = self.status
        self.updateStatus()
        if currentStatus != self.status {
            self.notifyStatusChange()
        }

        if self.status == .allowed && !self.isLocationUpdatingStarted {
            self.locationManager.startUpdatingLocation()
            self.isLocationUpdatingStarted = true
        }
    }

    func updateStatus() {
        if !CLLocationManager.locationServicesEnabled() {
            self.status = .globalDisabled
            return
        }
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.status = .allowed
        case .notDetermined:
            self.status = .unknown
        default:
            self.status = .denied
        }
    }

    func notifyStatusChange() {
        if let listeners = self.listeners.allObjects as? [LocationManagerStatusChangeListener] {
            listeners.forEach { $0.statusChange(self) }
        }
    }

    func updateCurrentLocation(_ clLocation: CLLocation?) {
        guard let clLocation = clLocation else { return }
        self.currentLocation = Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
    }
}
