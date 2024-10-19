//
//  ebookList.swift
//  Query
//
//  Created by Fernanda Girelli on 10/16/24.
//

import Foundation
import Combine


//https://itunes.apple.com/search?term=jack+johnson&entity=ebook&limit=10.
//https://itunes.apple.com/lookup?isbn=9780316069359.

class ebookListViewModel: ObservableObject
{
    @Published var searchTerm: String = ""
    @Published var eBooks: [eBook] = [eBook]()
    
    var subscriptions = Set<AnyCancellable>()
    
    
    init()
    {
        $searchTerm
            .sink{[weak self] term in self?.fetchEbook(for: term)}.store(in: &subscriptions)
    }
    func fetchEbook(for searchTerm: String)
    {
        guard let url = URL(string:"https://itunes.apple.com/search?term=jack+johnson&entity=ebook&limit=10")else
        {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error
            {
                print("error \(error.localizedDescription)")
            }else if let data = data {
                do {
                    
                    let result = try JSONDecoder().decode(ebookResult.self, from: data)
                    print(result.results)
                    DispatchQueue.main.async
                    {
                        self.eBooks = result.results
                        print(result.results)
                    }
                   
                    
                } catch
                {
                    print("decodo error")
                }
            }
            
        }.resume()
    }
}
