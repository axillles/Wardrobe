# AI Wardrobe - OpenAI Integration Guide

## Overview

Your AI Wardrobe app now has complete OpenAI integration for:
1. **Image Analysis**: When users upload clothing items, AI analyzes them and extracts detailed JSON metadata
2. **Outfit Generation**: AI generates stylish outfit combinations based on clothing descriptions

## Setup Instructions

### 1. Add Your OpenAI API Key

Open `AIWardrobe/Sources/Utilities/Config.swift` and replace:

```swift
static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
```

with your actual OpenAI API key:

```swift
static let openAIAPIKey = "sk-proj-..."
```

**Get your API key**: https://platform.openai.com/api-keys

### 2. Database Schema Update

You need to update your Supabase `clothing_items` table to include the new `ai_description` column:

```sql
ALTER TABLE clothing_items
ADD COLUMN ai_description TEXT;
```

Run this SQL in your Supabase SQL Editor: https://supabase.com/dashboard/project/_/sql

## How It Works

### 🔍 Image Analysis Flow

1. **User uploads a clothing image** → `AddClothingItemView`
2. **Image sent to OpenAI Vision API** → `OpenAIService.analyzeClothingImage()`
3. **AI returns detailed JSON** including:
   - Detailed description
   - Dominant colors
   - Pattern (solid, striped, plaid, etc.)
   - Material (cotton, denim, leather, etc.)
   - Style tags (casual, modern, vintage, etc.)
   - Formality level (casual, smart casual, business casual, formal, athletic)
   - Season suitability (spring, summer, fall, winter)
   - Occasions (everyday, work, party, athletic, etc.)
   - Fit type (tight, fitted, regular, relaxed, oversized)
   - Condition assessment

4. **JSON stored with clothing item** in `ClothingItem.aiDescription`

### 👔 Outfit Generation Flow

1. **User requests outfit suggestions** → `OutfitsView`
2. **App fetches all clothing items** with AI descriptions
3. **Array of JSON descriptions sent to OpenAI** → `OpenAIService.generateOutfits()`
4. **AI analyzes combinations** considering:
   - Color harmony
   - Style compatibility
   - Occasion appropriateness
   - Season suitability
   - Formality matching

5. **AI returns outfit recommendations** with:
   - Outfit name and description
   - Item IDs to combine
   - Reasoning for the combination
   - Styling tips
   - Season suitability

## Code Architecture

### New Files Created

#### `Sources/Services/OpenAIService.swift`
- `analyzeClothingImage(imageData:)` - Calls GPT-4 Vision API to analyze clothing images
- `generateOutfits(from:occasion:season:maxOutfits:)` - Generates outfit recommendations using GPT-4
- Handles API requests, error handling, and JSON parsing

### Modified Files

#### `Sources/Utilities/Config.swift`
- Added `openAIAPIKey` property

#### `Sources/Models/ClothingItem.swift`
- Added `aiDescription: String?` field to store JSON

#### `Sources/Services/AIOutfitService.swift`
- Updated to use `OpenAIService` instead of placeholder logic
- `analyzeClothingImage()` now calls OpenAI Vision API
- `generateOutfitSuggestions()` now uses AI-generated outfit recommendations

#### `Sources/ViewModels/WardrobeViewModel.swift`
- `addItem()` now analyzes images with AI before saving
- Gracefully handles AI failures (continues without description if AI fails)

### Existing Models Used

#### `Sources/Models/ClothingDescription.swift`
- Structured format for AI image analysis results
- Includes helper methods for JSON serialization

#### `Sources/Models/Outfit.swift`
- Standard outfit model with AI generation flag

## AI Prompts

### Image Analysis Prompt

```
You are a fashion expert analyzing clothing items. Analyze the provided image and 
return ONLY a valid JSON object with detailed information about the clothing item.

Analyze this clothing item image and provide detailed information in JSON format...
```

**Temperature**: 0.3 (more deterministic)
**Max Tokens**: 1000
**Model**: gpt-4o

### Outfit Generation Prompt

```
You are an expert fashion stylist. Your task is to create stylish, cohesive outfit 
combinations from the provided clothing items. Consider color harmony, style 
compatibility, occasion appropriateness, and seasonal suitability.

Based on the following clothing items (provided as JSON), create X complete outfit 
combinations...
```

**Temperature**: 0.7 (more creative)
**Max Tokens**: 2500
**Model**: gpt-4o

## Cost Estimation

### Image Analysis (per image)
- **Model**: GPT-4o with vision
- **Input**: ~500 tokens (prompt + image)
- **Output**: ~200 tokens (JSON response)
- **Cost**: ~$0.01-0.02 per image

### Outfit Generation (per request)
- **Model**: GPT-4o
- **Input**: ~500-2000 tokens (depending on number of items)
- **Output**: ~500-1000 tokens (5 outfits)
- **Cost**: ~$0.02-0.05 per generation

**Total**: Very affordable for a wardrobe app!

## Error Handling

The integration includes robust error handling:

1. **Invalid API Key**: Clear error message if key is missing or invalid
2. **Network Errors**: Gracefully handled with user-friendly messages
3. **AI Analysis Failure**: App continues without AI description (doesn't block adding items)
4. **No AI Descriptions**: Outfit generation returns empty array if no items have descriptions

## Testing Checklist

- [ ] Add your OpenAI API key to `Config.swift`
- [ ] Update Supabase database schema with `ai_description` column
- [ ] Build the project (no compilation errors)
- [ ] Upload a clothing item
- [ ] Verify AI description is stored (check database)
- [ ] Add multiple clothing items
- [ ] Generate outfit suggestions
- [ ] Verify outfit recommendations are relevant

## Usage Tips

### For Best AI Results

1. **Clear, well-lit photos**: Better image quality = better AI analysis
2. **Single items**: Photograph one clothing item at a time
3. **Full view**: Include the entire item in the frame
4. **Neutral background**: Helps AI focus on the clothing

### Customizing AI Behavior

You can modify the prompts in `OpenAIService.swift` to:
- Focus on specific attributes (e.g., sustainability, brand recognition)
- Add more detailed styling instructions
- Include user preferences in outfit generation
- Adjust creativity level (temperature parameter)

## Future Enhancements

Potential improvements you could add:

1. **User Style Profile**: Include user preferences in outfit generation
2. **Weather Integration**: Factor in weather when suggesting outfits
3. **Batch Processing**: Analyze multiple images at once
4. **Outfit History**: Learn from user's favorite outfits
5. **Virtual Try-On**: Use DALL-E to visualize outfits
6. **Style Recommendations**: Suggest new items to complete outfits

## Troubleshooting

### "Invalid API Key" Error
- Verify your API key is correct in `Config.swift`
- Ensure you have credits in your OpenAI account
- Check API key permissions

### AI Analysis Takes Too Long
- Normal processing time: 3-10 seconds per image
- Check your internet connection
- Verify OpenAI API status

### Outfit Generation Returns Empty Array
- Ensure clothing items have AI descriptions
- Add more items (need at least 2-3 items)
- Check that items were analyzed successfully

### Database Errors
- Verify `ai_description` column exists in Supabase
- Check column type is TEXT
- Ensure proper permissions

## Support

If you encounter issues:
1. Check the Xcode console for detailed error messages
2. Verify OpenAI API status: https://status.openai.com
3. Review Supabase logs for database issues
4. Test with a simple clothing image first

## Security Notes

⚠️ **Important**:
- Never commit your API key to version control
- Consider using environment variables or secure key storage in production
- Implement rate limiting for API calls
- Monitor API usage to control costs

---

**That's it!** You now have a fully functional AI-powered wardrobe app. Just add your OpenAI API key and update your database schema, and you're ready to go! 🎉
