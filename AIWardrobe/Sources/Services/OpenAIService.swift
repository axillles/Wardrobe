import Foundation
import UIKit

enum OpenAIError: Error {
    case invalidAPIKey
    case invalidResponse
    case decodingError
    case networkError(Error)
    case apiError(String)
}

class OpenAIService {
    static let shared = OpenAIService()
    
    private let apiKey: String
    private let visionModel = "gpt-4o"
    private let chatModel = "gpt-4o"
    private let baseURL = "https://api.openai.com/v1"
    
    private init() {
        self.apiKey = Config.openAIAPIKey
    }
    
    // MARK: - Image Analysis
    
    /// Analyzes a clothing item image and returns detailed JSON description
    func analyzeClothingImage(imageData: Data) async throws -> ClothingDescription {
        let base64Image = imageData.base64EncodedString()
        
        let systemPrompt = """
        You are a fashion expert analyzing clothing items. Analyze the provided image and return ONLY a valid JSON object with detailed information about the clothing item.
        """
        
        let userPrompt = """
        Analyze this clothing item image and provide detailed information in the following JSON format:
        
        {
          "detailedDescription": "A comprehensive description of the item",
          "dominantColors": ["color1", "color2"],
          "pattern": "solid/striped/plaid/floral/etc or null",
          "material": "cotton/denim/leather/etc or null",
          "style": ["casual", "modern", "vintage", etc],
          "formality": "casual/smart_casual/business_casual/formal/athletic",
          "season": ["spring", "summer", "fall", "winter"],
          "occasion": ["everyday", "work", "party", "athletic", etc],
          "fit": "tight/fitted/regular/relaxed/oversized or null",
          "condition": "excellent/good/fair or null"
        }
        
        Be specific and accurate. Return ONLY the JSON object, no additional text.
        """
        
        let payload: [String: Any] = [
            "model": visionModel,
            "messages": [
                [
                    "role": "system",
                    "content": systemPrompt
                ],
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": userPrompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 1000,
            "temperature": 0.3
        ]
        
        let response = try await makeAPIRequest(endpoint: "/chat/completions", payload: payload)
        
        guard let choices = response["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw OpenAIError.invalidResponse
        }
        
        // Parse JSON from response
        let cleanedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let jsonData = cleanedContent.data(using: .utf8) else {
            throw OpenAIError.decodingError
        }
        
        // Decode into temporary structure, then create ClothingDescription
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        struct TempResponse: Codable {
            let detailedDescription: String
            let dominantColors: [String]
            let pattern: String?
            let material: String?
            let style: [String]
            let formality: String
            let season: [String]
            let occasion: [String]
            let fit: String?
            let condition: String?
        }
        
        let tempResponse = try decoder.decode(TempResponse.self, from: jsonData)
        
        // Create ClothingDescription (need a temporary UUID that will be replaced)
        let description = ClothingDescription(
            itemId: UUID(),
            detailedDescription: tempResponse.detailedDescription,
            dominantColors: tempResponse.dominantColors,
            pattern: tempResponse.pattern,
            material: tempResponse.material,
            style: tempResponse.style,
            formality: ClothingDescription.FormalityLevel(rawValue: tempResponse.formality) ?? .casual,
            season: tempResponse.season,
            occasion: tempResponse.occasion,
            fit: tempResponse.fit.flatMap { ClothingDescription.FitType(rawValue: $0) },
            condition: tempResponse.condition
        )
        
        return description
    }
    
    // MARK: - Outfit Generation
    
    /// Generates outfit recommendations from clothing descriptions
    func generateOutfits(
        from descriptions: [ClothingDescription],
        occasion: String? = nil,
        season: String? = nil,
        maxOutfits: Int = 5
    ) async throws -> [OutfitRecommendation] {
        let systemPrompt = """
        You are an expert fashion stylist. Your task is to create stylish, cohesive outfit combinations from the provided clothing items. Consider color harmony, style compatibility, occasion appropriateness, and seasonal suitability.
        """
        
        let descriptionsJSON = try JSONEncoder().encode(descriptions)
        let descriptionsString = String(data: descriptionsJSON, encoding: .utf8) ?? "[]"
        
        var userPrompt = """
        Based on the following clothing items (provided as JSON), create \(maxOutfits) complete outfit combinations.
        
        Clothing items:
        \(descriptionsString)
        """
        
        if let occasion = occasion {
            userPrompt += "\n\nOccasion: \(occasion)"
        }
        
        if let season = season {
            userPrompt += "\n\nSeason: \(season)"
        }
        
        userPrompt += """
        
        
        Return ONLY a JSON array of outfit recommendations in this exact format:
        
        [
          {
            "outfitName": "Outfit name",
            "description": "Brief description of the outfit",
            "occasion": "Suitable occasion",
            "styleVibe": "Overall style vibe",
            "itemIds": ["uuid1", "uuid2", "uuid3"],
            "reasoning": "Why these items work together",
            "seasonSuitability": ["spring", "summer"],
            "tips": ["styling tip 1", "styling tip 2"]
          }
        ]
        
        Requirements:
        - Each outfit should have 2-5 items
        - Ensure color harmony and style compatibility
        - Mix categories appropriately (tops, bottoms, shoes, accessories, etc.)
        - Consider formality levels
        - Provide practical styling tips
        
        Return ONLY the JSON array, no additional text.
        """
        
        let payload: [String: Any] = [
            "model": chatModel,
            "messages": [
                [
                    "role": "system",
                    "content": systemPrompt
                ],
                [
                    "role": "user",
                    "content": userPrompt
                ]
            ],
            "max_tokens": 2500,
            "temperature": 0.7
        ]
        
        let response = try await makeAPIRequest(endpoint: "/chat/completions", payload: payload)
        
        guard let choices = response["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw OpenAIError.invalidResponse
        }
        
        // Parse JSON array from response
        let cleanedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let jsonData = cleanedContent.data(using: .utf8) else {
            throw OpenAIError.decodingError
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let outfitRecommendations = try decoder.decode([OutfitRecommendation].self, from: jsonData)
        
        return outfitRecommendations
    }
    
    // MARK: - Private Helper Methods
    
    private func makeAPIRequest(endpoint: String, payload: [String: Any]) async throws -> [String: Any] {
        // Validate API key
        guard !apiKey.isEmpty && apiKey != "YOUR_OPENAI_API_KEY_HERE" else {
            print("❌ OpenAI API key is not configured. Please update Config.swift with your actual API key.")
            throw OpenAIError.invalidAPIKey
        }
        
        // Validate API key format (should start with sk-)
        guard apiKey.hasPrefix("sk-") else {
            print("❌ OpenAI API key format is invalid. It should start with 'sk-'")
            throw OpenAIError.invalidAPIKey
        }
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            print("❌ Invalid OpenAI API URL: \(baseURL)\(endpoint)")
            throw OpenAIError.networkError(URLError(.badURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60.0 // Set timeout to 60 seconds
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload)
            request.httpBody = jsonData
            
            print("🌐 Making OpenAI API request to: \(url)")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response from OpenAI API")
                throw OpenAIError.networkError(URLError(.badServerResponse))
            }
            
            print("📡 OpenAI API response status: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                // Try to parse error response
                if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = errorResponse["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    print("❌ OpenAI API error (\(httpResponse.statusCode)): \(message)")
                    throw OpenAIError.apiError("OpenAI API Error: \(message)")
                } else {
                    print("❌ OpenAI API returned status code: \(httpResponse.statusCode)")
                    let responseString = String(data: data, encoding: .utf8) ?? "No response body"
                    print("Response: \(responseString)")
                    throw OpenAIError.apiError("OpenAI API returned status code: \(httpResponse.statusCode)")
                }
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("❌ Failed to decode OpenAI API response as JSON")
                throw OpenAIError.decodingError
            }
            
            print("✅ OpenAI API request successful")
            return json
            
        } catch let error as OpenAIError {
            throw error
        } catch let urlError as URLError {
            print("❌ Network error: \(urlError.localizedDescription)")
            switch urlError.code {
            case .notConnectedToInternet:
                throw OpenAIError.networkError(urlError)
            case .timedOut:
                throw OpenAIError.networkError(urlError)
            case .cannotConnectToHost:
                throw OpenAIError.networkError(urlError)
            default:
                throw OpenAIError.networkError(urlError)
            }
        } catch {
            print("❌ Unexpected error: \(error.localizedDescription)")
            throw OpenAIError.networkError(error)
        }
    }
}
