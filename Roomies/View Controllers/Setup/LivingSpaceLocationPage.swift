//
//  LivingSpaceLocationPage.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import SwiftLocation
import MapKit

class LivingSpaceLocationPage: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapLabel: UILabel!

    private var places = [PlaceMatch]()
    private var chosenAddress: PhysicalAddress? = nil
    
    public var setupViewController: SetupViewController?

    override func viewDidLoad() {
        self.locationTableView.alpha = 0.0
        self.nextButton.alpha = 0.0
        self.mapView.alpha = 0.0
        self.mapLabel.alpha = 0.0
        self.searchTextField.addTarget(self, action: #selector(handleTextFieldChanged), for: .editingChanged)
        self.searchTextField.delegate = self

        LocationManager.shared.requireUserAuthorization()
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let chosenAddress = self.chosenAddress, let setupViewController = self.setupViewController {
            setupViewController.setChosenAddress(chosenAddress)
            setupViewController.goToNextPage()
        }
    }

    private func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Keaton", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }


    @objc private func handleTextFieldChanged() {
        if let place = self.searchTextField.text {
            LocationManager.shared.autocomplete(partialMatch: .partialSearch(place), service: .apple(nil)) { result in
                switch result {
                case .failure(let error):
                    debugPrint("Request failed: \(error)")
                case .success(let places):
                    self.places = places
                    self.locationTableView.reloadData()
                    self.showLocationTableView()
                }
            }
        }
    }

    private func showLocationTableView() {
        if self.locationTableView.alpha < 1.0 {
            UIView.animate(withDuration: 0.15) {
                self.locationTableView.alpha = 1.0
            }
        }
    }

    private func hideLocationTableView() {
        UIView.animate(withDuration: 0.3) {
            self.locationTableView.alpha = 0.0
        }
    }


    private func hideNextButton() {
        UIView.animate(withDuration: 0.3) {
            self.nextButton.alpha = 0.0
        }
    }

    private func hideMapView() {
        UIView.animate(withDuration: 0.3) {
            self.mapView.alpha = 0.0
            self.mapLabel.alpha = 0.0
        }
    }

    private func showNextButton() {
        UIView.animate(withDuration: 0.3) {
            self.nextButton.alpha = 1.0
        }
    }

    private func showMapView(atAddress address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else { return }
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            let annotation = MKPointAnnotation()

            self.setPhysicalAddress(fromPlacemark: placemarks.first)
            annotation.coordinate = location.coordinate

            UIView.animate(withDuration: 0.3, animations: {
                self.mapView.alpha = 1.0
                self.mapLabel.alpha = 1.0
            }) { (didComplete) in
                if (didComplete) {
                    self.mapView.setCenter(location.coordinate, animated: true)
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(self.mapView.regionThatFits(viewRegion), animated: true)
                }
            }
        }
    }

    private func setPhysicalAddress(fromPlacemark placemark: CLPlacemark?) {
        if let placemark = placemark, let postalAddress = placemark.postalAddress {
            self.chosenAddress = PhysicalAddress(fromPostalAddress: postalAddress)
        }
    }
}


extension LivingSpaceLocationPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell")
        cell?.textLabel?.text = self.places[indexPath.row].partialMatch?.title
        cell?.detailTextLabel?.text = self.places[indexPath.row].partialMatch?.subtitle

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partialMatch = self.places[indexPath.row].partialMatch!
        let address = partialMatch.title + ", " + partialMatch.subtitle

        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = address
        self.statusView.tintColor = UIColor.systemGreen
        self.hideLocationTableView()
        self.showNextButton()
        self.showMapView(atAddress: address)


        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LivingSpaceLocationPage: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideMapView()
        self.hideNextButton()
        self.chosenAddress = nil
    }
}
