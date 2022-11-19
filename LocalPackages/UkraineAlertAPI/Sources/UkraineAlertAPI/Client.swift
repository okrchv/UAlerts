//
//  Client.swift
//  
//
//  Created by Oleh Kiurchev on 03.08.2022.
//

import Foundation
import Get

public actor Client {
    public static let shared = Client()
    
    private var client: APIClient
    
    public init(_ configure: (inout APIClient.Configuration) -> Void = { _ in }) {
        var configuration = APIClient.Configuration(baseURL: URL(string: "https://siren.pp.ua"))
        configure(&configuration)
        
        self.client = APIClient.init(configuration: configuration)
    }
    
    public func send<T: Decodable>(_ request: Request<T>) async throws -> Response<T> {
        try await self.client.send(request)
    }
}
