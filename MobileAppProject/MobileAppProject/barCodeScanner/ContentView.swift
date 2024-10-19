//
//  ContentView.swift
//  barCodeScanner
//
//  Created by Fernanda Girelli on 10/9/24.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
    @State var ScannerUse = false
    @State var scannedCode: String = "Scan a book"
    
    var scannerSheet : some View
    {
        CodeScannerView(codeTypes: [.ean8, .ean13, .upce, .code128, .code39, .pdf417], completion:{
            result in
            if case let .success(code)=result {
                self.scannedCode = code.string
                self.ScannerUse = false
            }
        }
        )
    }
    var body: some View {
        VStack {
            Text("Barcode Scanner!")
            Text(scannedCode)
            Button("Press Me")
            {
                self.ScannerUse = true
            }
            .sheet(isPresented: $ScannerUse)
            {
                self.scannerSheet
            }
            searchedBook()
          
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
