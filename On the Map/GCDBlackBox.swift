//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by Andreas on 11/10/16.
//  Copyright © 2016 Andreas. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void) {
    DispatchQueue.main.async() {
        updates()
    }
}
