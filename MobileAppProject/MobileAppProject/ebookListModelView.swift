//
//  ebookList.swift
//  Query
//
//  Created by Fernanda Girelli on 10/16/24.
//

import Foundation
import Combine




class ebookListModelView: ObservableObject
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
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(searchTerm)")else
        {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error
            {
                print("error \(error.localizedDescription)")
            }
            else if let data = data {
                do {
                    
                    let result = try JSONDecoder().decode(eBookResult.self, from: data)
                    
                    DispatchQueue.main.async
                        {
                            self.eBooks = result.items
                            
                        }
                   
                    } catch
                        {
                            print("decode error")
                        }
                    }
            
        }.resume()
    }
}
