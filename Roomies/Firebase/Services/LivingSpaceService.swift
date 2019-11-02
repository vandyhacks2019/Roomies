//
//  LivingSpaceService.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import Ballcap

class LivingSpaceService {
    static let sharedInstance = LivingSpaceService()

    private var livingSpacesRef: CollectionReference

    private (set) public var currentLivingSpace = ReplaySubject<LivingSpace>.createUnbounded()

    /// Private initializer for the singleton goodness
    private init() {
        self.livingSpacesRef = Firestore.firestore().collection("livingSpaces")
    }

    /// Fetch all living spaces for a user reference
    public func fetchLivingSpaces(forUser userRef: DocumentReference) -> DataSource<Document<LivingSpace>> {
        let query: DataSource<Document<LivingSpace>>.Query = DataSource.Query(self.livingSpacesRef.whereField("residents", arrayContains: userRef.documentID))
        let dataSource = DataSource(reference: query)

        return dataSource.retrieve(from: { (snapshot, documentSnapshot, done) in
            let document: Document<LivingSpace> = Document(documentSnapshot.reference)
            document.get { (item, error) in
                done(item!)
            }
        })
    }

    /// Fetch a living space, looking it up by a PhysicalAddress object
    public func fetchLivingSpace(forAddress address: PhysicalAddress) -> Observable<Document<LivingSpace>> {
        Observable.create { observer in
            if let query = self.buildAddressQuery(address) {
                DataSource<Document<LivingSpace>>.Query(query)
                    .limit(to: 1)
                    .dataSource()
                    .sorted(by: { $0.updatedAt > $1.updatedAt })
                    .retrieve(from: { (snapshot, documentSnapshot, done) in
                        let document: Document<LivingSpace> = Document(documentSnapshot.reference)
                        document.get { (document: Document<LivingSpace>?, error) in
                            if let document = document, let livingSpace = document.data {
                                observer.onNext(document)
                                self.currentLivingSpace.onNext(livingSpace)
                            } else if let fetchError = error {
                                observer.onError(fetchError)
                            }
                        }
                    })
                    .get()
            } else {
                observer.onError(DataError.emptyArrayError(message: "No living spaces found for address"))
            }
            return Disposables.create()
        }
    }

    /// Create a new LivingSpace  on the Firebase backend, returns a Document<LivingSpace> object.
    public func createLivingSpace(forUser appUser: AppUser, name: String, address: PhysicalAddress? = nil) -> Observable<Document<LivingSpace>> {
        return self.attachAddressToAppUser(address, appUser: appUser).flatMap { (didSucceed: Bool) -> Observable<Document<LivingSpace>> in
            if didSucceed {
                let newLivingSpace = LivingSpace(name: name, createdBy: appUser.userID!, address: address)
                let newDocumentRef = self.livingSpacesRef.addDocument(from: newLivingSpace)
                let newDocument = Document<LivingSpace>(newDocumentRef)

                return Observable.create { observer in
                    newDocument.get { (document, error) in
                        if let document = document, let livingSpace = document.data {
                            observer.onNext(document)
                            self.currentLivingSpace.onNext(livingSpace)
                        } else if let createError = error {
                            observer.onError(createError)
                        }
                    }
                    return Disposables.create()
                }
            }
            return Observable.error(DataError.uniqueConstraintsError(message: "User already has location at address"))
        }
    }

    /// Delete a LivingSpace on the Firebase backend
    public func deleteLivingSpace(_ livingSpaceDocument: Document<LivingSpace>) -> Observable<Bool> {
        return Observable.create { observer in
            livingSpaceDocument.delete { (error) in
                if let deleteError = error {
                    observer.onError(deleteError)
                } else {
                    observer.onNext(true)
                }
            }
            return Disposables.create()
        }
    }

    /// Update a LivingSpace on the Firebase backend
    public func updateLivingSpace(_ livingSpaceDocument: Document<LivingSpace>) -> Observable<Bool> {
        return Observable.create { observer in
            livingSpaceDocument.update { (error) in
                if let updateError = error {
                    observer.onError(updateError)
                } else {
                    observer.onNext(true)
                }
            }
            return Disposables.create()
        }
    }

    /// Build a Ballcap query from  a PhysicalAddress object
    private func buildAddressQuery(_ address: PhysicalAddress) -> Query? {
        var addressQuery: Query?

        address.queryValue.keys.forEach { addressComponentKey in
            let base = addressQuery != nil ? addressQuery! : self.livingSpacesRef
            let addressComponent: String = address.queryValue[addressComponentKey]!
            print("address.\(addressComponentKey) === \(addressComponent)")
            addressQuery = base.whereField("address.\(addressComponentKey)", isEqualTo: addressComponent)
        }
        return addressQuery
    }

    /// Attach a PhysicalAddress to a user on the Firebase backend
    private func attachAddressToAppUser(_ address: PhysicalAddress?, appUser: AppUser) -> Observable<Bool> {
        return Observable.create { observer in
            if let address = address {
                var appUser = appUser
                let appUserDocument = Document<AppUser>(Firestore.firestore().collection("users").document(appUser.userID!))

                if appUser.livingSpaceAddresses != nil && !appUser.livingSpaceAddresses!.contains(address) {
                    appUser.livingSpaceAddresses!.append(address)
                } else if appUser.livingSpaceAddresses == nil {
                    appUser.livingSpaceAddresses = [address]
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }


                appUserDocument.data = appUser
                appUserDocument.update { (error) in
                    if let updateError = error {
                        observer.onError(updateError)
                        observer.onCompleted()
                    }
                    observer.onNext(true)
                }
            } else {
                observer.onNext(true)
            }
            return Disposables.create()
        }
    }
}
