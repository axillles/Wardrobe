# Example API Responses

This document shows example responses from the OpenAI integration to help you understand the data structure.

## Image Analysis Response

When a user uploads a clothing image, the OpenAI Vision API analyzes it and returns a JSON object like this:

### Example 1: Blue Denim Jacket

```json
{
  "detailedDescription": "A classic blue denim jacket with brass buttons, two chest pockets, and a slightly faded wash. The jacket has a traditional trucker style with a pointed collar and adjustable waist tabs.",
  "dominantColors": ["blue", "indigo"],
  "pattern": "solid",
  "material": "denim",
  "style": ["casual", "classic", "americana"],
  "formality": "casual",
  "season": ["spring", "fall", "winter"],
  "occasion": ["everyday", "casual outing", "weekend"],
  "fit": "regular",
  "condition": "good"
}
```

### Example 2: Black Leather Shoes

```json
{
  "detailedDescription": "Sleek black leather oxford shoes with lace-up closure, featuring a polished finish and classic cap-toe design. Professional appearance with minimal wear.",
  "dominantColors": ["black"],
  "pattern": "solid",
  "material": "leather",
  "style": ["formal", "classic", "professional"],
  "formality": "formal",
  "season": ["spring", "summer", "fall", "winter"],
  "occasion": ["work", "formal event", "business meeting"],
  "fit": null,
  "condition": "excellent"
}
```

### Example 3: White Cotton T-Shirt

```json
{
  "detailedDescription": "Simple white cotton crew-neck t-shirt with short sleeves. Classic basic piece with a clean, minimalist design.",
  "dominantColors": ["white"],
  "pattern": "solid",
  "material": "cotton",
  "style": ["casual", "minimalist", "basic"],
  "formality": "casual",
  "season": ["spring", "summer"],
  "occasion": ["everyday", "casual outing", "layering piece"],
  "fit": "regular",
  "condition": "excellent"
}
```

### Example 4: Striped Summer Dress

```json
{
  "detailedDescription": "Light blue and white vertical striped sleeveless summer dress with a fitted bodice and flared skirt. Features a v-neckline and falls to knee length.",
  "dominantColors": ["blue", "white"],
  "pattern": "striped",
  "material": "cotton",
  "style": ["casual", "feminine", "nautical"],
  "formality": "casual",
  "season": ["spring", "summer"],
  "occasion": ["casual outing", "brunch", "beach", "daytime event"],
  "fit": "fitted",
  "condition": "excellent"
}
```

## Outfit Generation Response

When requesting outfit recommendations, the AI receives all clothing descriptions and returns outfit combinations:

### Example Request Context

User has these items in wardrobe:
- Blue denim jacket
- White cotton t-shirt
- Black jeans
- Black leather shoes
- Brown leather belt

### Example Response

```json
[
  {
    "outfitName": "Smart Casual Classic",
    "description": "A timeless combination perfect for casual Friday or weekend outings",
    "occasion": "Casual outing",
    "styleVibe": "Classic casual",
    "itemIds": [
      "550e8400-e29b-41d4-a716-446655440001",
      "550e8400-e29b-41d4-a716-446655440002",
      "550e8400-e29b-41d4-a716-446655440003",
      "550e8400-e29b-41d4-a716-446655440004"
    ],
    "reasoning": "The white t-shirt provides a clean base, while the denim jacket adds texture and casual sophistication. Black jeans keep the look grounded, and leather shoes elevate the outfit from basic to put-together. The brown belt adds a subtle contrast.",
    "seasonSuitability": ["spring", "fall"],
    "tips": [
      "Roll up the denim jacket sleeves for a more relaxed vibe",
      "Keep the t-shirt tucked or partially tucked for a neater appearance",
      "This outfit works great for coffee dates or casual dinners"
    ]
  },
  {
    "outfitName": "Monochrome Minimalist",
    "description": "Sleek and simple black-on-black look with a statement denim layer",
    "occasion": "Everyday",
    "styleVibe": "Modern minimalist",
    "itemIds": [
      "550e8400-e29b-41d4-a716-446655440002",
      "550e8400-e29b-41d4-a716-446655440003",
      "550e8400-e29b-41d4-a716-446655440004"
    ],
    "reasoning": "A monochromatic black outfit creates a sleek silhouette, perfect for versatile everyday wear. The white t-shirt breaks up the darkness without overpowering the look.",
    "seasonSuitability": ["spring", "summer", "fall"],
    "tips": [
      "Add accessories like a watch or bracelet for personality",
      "Works well for running errands or casual meetups",
      "Layer with the denim jacket for cooler weather"
    ]
  },
  {
    "outfitName": "Casual Weekend Warrior",
    "description": "Relaxed but polished look for weekend activities",
    "occasion": "Weekend",
    "styleVibe": "Effortlessly cool",
    "itemIds": [
      "550e8400-e29b-41d4-a716-446655440001",
      "550e8400-e29b-41d4-a716-446655440002",
      "550e8400-e29b-41d4-a716-446655440003"
    ],
    "reasoning": "This combination balances comfort with style. The denim-on-denim-adjacent look is a classic that never fails, while the white t-shirt prevents it from being too matchy.",
    "seasonSuitability": ["spring", "fall"],
    "tips": [
      "Swap leather shoes for sneakers for a more casual vibe",
      "Leave the jacket unbuttoned for a more relaxed feel",
      "Perfect for exploring the city or attending outdoor events"
    ]
  },
  {
    "outfitName": "Elevated Basics",
    "description": "Simple pieces combined for maximum impact",
    "occasion": "Casual outing",
    "styleVibe": "Clean and refined",
    "itemIds": [
      "550e8400-e29b-41d4-a716-446655440002",
      "550e8400-e29b-41d4-a716-446655440003",
      "550e8400-e29b-41d4-a716-446655440004",
      "550e8400-e29b-41d4-a716-446655440005"
    ],
    "reasoning": "Sometimes the best outfit is the simplest. This combination lets quality pieces speak for themselves. The brown leather belt adds warmth and breaks up the monochrome palette.",
    "seasonSuitability": ["spring", "summer", "fall"],
    "tips": [
      "Ensure the t-shirt is crisp and well-fitted",
      "This is your go-to 'grab and go' outfit",
      "Add a watch to complete the look"
    ]
  },
  {
    "outfitName": "Layered Americana",
    "description": "Full classic American casual style with all pieces working together",
    "occasion": "Casual outing",
    "styleVibe": "Classic American casual",
    "itemIds": [
      "550e8400-e29b-41d4-a716-446655440001",
      "550e8400-e29b-41d4-a716-446655440002",
      "550e8400-e29b-41d4-a716-446655440003",
      "550e8400-e29b-41d4-a716-446655440004",
      "550e8400-e29b-41d4-a716-446655440005"
    ],
    "reasoning": "This is the quintessential casual uniform - denim jacket, white tee, black jeans, and leather accessories. It's a foolproof combination that works for almost any casual scenario.",
    "seasonSuitability": ["spring", "fall"],
    "tips": [
      "This outfit has endless styling variations - try cuffing the jeans",
      "Perfect for first dates, casual dinners, or social events",
      "The brown belt adds warmth against the cooler tones"
    ]
  }
]
```

## How the Data Flows

### 1. Upload Flow
```
User selects photo
    ↓
WardrobeViewModel.addItem()
    ↓
AIOutfitService.analyzeClothingImage()
    ↓
OpenAIService.analyzeClothingImage()
    ↓
[OpenAI Vision API Call]
    ↓
JSON Response (ClothingDescription)
    ↓
Stored in ClothingItem.aiDescription
    ↓
Saved to Supabase database
```

### 2. Outfit Generation Flow
```
User requests outfits
    ↓
OutfitViewModel.generateSuggestions()
    ↓
Fetch all ClothingItems from database
    ↓
Parse aiDescription JSONs
    ↓
AIOutfitService.generateOutfitSuggestions()
    ↓
OpenAIService.generateOutfits()
    ↓
[OpenAI Chat API Call with all descriptions]
    ↓
JSON Array Response (OutfitRecommendations)
    ↓
Convert to Outfit models
    ↓
Display to user
```

## Field Explanations

### ClothingDescription Fields

- **itemId**: UUID linking to the ClothingItem
- **detailedDescription**: Human-readable description of the item
- **dominantColors**: Array of main colors (e.g., ["blue", "white"])
- **pattern**: Type of pattern or "solid" (striped, plaid, floral, checkered, etc.)
- **material**: Fabric type (cotton, denim, leather, polyester, wool, etc.)
- **style**: Style tags as array (casual, formal, vintage, modern, athletic, etc.)
- **formality**: One of: casual, smart_casual, business_casual, formal, athletic
- **season**: Array of suitable seasons (spring, summer, fall, winter)
- **occasion**: Array of appropriate occasions (everyday, work, party, athletic, formal event, etc.)
- **fit**: One of: tight, fitted, regular, relaxed, oversized, or null
- **condition**: excellent, good, fair, or null

### OutfitRecommendation Fields

- **outfitName**: Creative name for the outfit
- **description**: Brief description of the overall look
- **occasion**: Primary occasion this outfit suits
- **styleVibe**: Overall aesthetic (e.g., "Modern minimalist", "Classic casual")
- **itemIds**: Array of ClothingItem UUIDs to combine
- **reasoning**: Why these items work well together
- **seasonSuitability**: Array of seasons this outfit works for
- **tips**: Array of styling suggestions and usage tips

## Customizing Prompts

You can modify the prompts in `OpenAIService.swift` to get different results:

### Make Analysis More Detailed
Increase `max_tokens` from 1000 to 1500 and add more fields to the JSON schema

### Make Outfits More Creative
Increase `temperature` from 0.7 to 0.9 for more varied combinations

### Focus on Specific Occasions
Add occasion parameter to the prompt: "Focus on work-appropriate outfits"

### Include User Preferences
Pass user style preferences in the prompt: "The user prefers minimalist, monochrome styles"

---

These examples should help you understand what data to expect from the AI integration!
