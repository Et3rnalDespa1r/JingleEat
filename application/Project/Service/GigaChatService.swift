import Foundation

class GigaChatService: NSObject, URLSessionDelegate {
    static let shared = GigaChatService()
    
    private let authData = "MmExNGRhNzctZjU3OC00YWM2LTg4ZjUtMjI1NGQ4YTMwOTEwOjVmMzU1Njc0LTk4MjQtNDQ4NS1iZWJhLTI4YmRmYTA5YTBmNA=="
    private let scope = "GIGACHAT_API_PERS"
    
    private var accessToken: String?
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    // MARK: - Получение токена (OAuth)
    func authenticate() async throws {
        let url = URL(string: "https://ngw.devices.sberbank.ru:9443/api/v2/oauth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        

        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(UUID().uuidString, forHTTPHeaderField: "RqUID")
        
        let bodyString = "scope=\(scope)"
        request.httpBody = bodyString.data(using: .utf8)
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Auth Error: \(httpResponse.statusCode), \(errorText)")
            throw NSError(domain: "GigaChatAuth", code: httpResponse.statusCode)
        }
        
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        self.accessToken = tokenResponse.access_token
        print("GigaChat: Токен успешно обновлен")
    }

    // MARK: - Отправка сообщения (RAG)
    func sendMessage(prompt: String) async throws -> String {
        if accessToken == nil {
            try await authenticate()
        }
        
        let url = URL(string: "https://gigachat.devices.sberbank.ru/api/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let token = accessToken else { return "Ошибка авторизации" }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let messages = [
            GigaChatMessage(role: "user", content: prompt)
        ]
        
        let payload = GigaChatRequest(model: "GigaChat", messages: messages, temperature: 0.3)
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await authenticate()
            return try await sendMessage(prompt: prompt)
        }
        
        let chatResponse = try JSONDecoder().decode(GigaChatResponse.self, from: data)
        return chatResponse.choices.first?.message.content ?? "Пустой ответ"
    }

    // MARK: - Обработка сертификатов Минцифры
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let trust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
