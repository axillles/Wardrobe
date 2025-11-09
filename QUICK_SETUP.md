# Quick Setup Checklist ✅

Follow these steps to get your AI Wardrobe up and running:

## Step 1: Get OpenAI API Key 🔑

1. Go to https://platform.openai.com/api-keys
2. Sign in or create an account
3. Click "Create new secret key"
4. Copy your API key (starts with `sk-proj-...`)
5. **Keep it secret!** Don't share it or commit it to git

## Step 2: Add API Key to Your Project 💻

1. Open `AIWardrobe/Sources/Utilities/Config.swift`
2. Find this line:
   ```swift
   static let openAIAPIKey = "YOUR_OPENAI_API_KEY_HERE"
   ```
3. Replace with your actual key:
   ```swift
   static let openAIAPIKey = "sk-proj-your-actual-key-here"
   ```
4. Save the file

## Step 3: Update Database Schema 🗄️

1. Open Supabase Dashboard: https://supabase.com/dashboard
2. Select your project
3. Go to "SQL Editor" in the left sidebar
4. Copy the SQL from `supabase_migration.sql` file
5. Paste it into the SQL editor
6. Click "Run" to execute the migration
7. Verify the `ai_description` column was added successfully

**Quick SQL (copy-paste this):**
```sql
ALTER TABLE clothing_items
ADD COLUMN IF NOT EXISTS ai_description TEXT;
```

## Step 4: Build and Test 🚀

1. Open your project in Xcode
2. Build the project (⌘ + B)
3. Fix any compilation errors if they appear
4. Run on simulator or device (⌘ + R)

## Step 5: Test the AI Integration 🧪

### Test Image Analysis:
1. Launch the app
2. Sign in or create an account
3. Go to "Wardrobe" tab
4. Tap the "+" button to add a clothing item
5. Select a photo of clothing (or take a photo)
6. Fill in category, brand, season
7. Tap "Add to Wardrobe"
8. **Wait 5-10 seconds** for AI analysis
9. Check your Supabase database to verify `ai_description` was populated

### Test Outfit Generation:
1. Add at least 3-5 clothing items (with different categories)
2. Go to "Outfits" tab
3. Tap "Generate Suggestions" or similar button
4. **Wait 5-15 seconds** for AI to generate outfits
5. View the suggested outfit combinations
6. Verify they make sense and are stylish

## Troubleshooting 🔧

### ❌ "Invalid API Key" Error
- Double-check your API key in `Config.swift`
- Make sure you copied the entire key
- Verify your OpenAI account has credits

### ❌ Build Errors
- Clean build folder: Product → Clean Build Folder (⌘ + Shift + K)
- Close and reopen Xcode
- Verify all files are in the project

### ❌ Database Errors
- Verify the migration ran successfully in Supabase
- Check table permissions in Supabase
- Make sure you're signed in to the app

### ❌ AI Takes Too Long
- Normal: 3-10 seconds for image analysis
- Normal: 5-15 seconds for outfit generation
- Check your internet connection
- Verify OpenAI API status: https://status.openai.com

### ❌ Outfit Generation Returns Nothing
- Add more clothing items (need at least 3)
- Verify items have AI descriptions (check database)
- Make sure you have variety (tops, bottoms, shoes)

## Cost Monitoring 💰

Keep track of your OpenAI usage:
1. Go to https://platform.openai.com/usage
2. View your API usage and costs
3. Set up billing alerts if needed

**Expected costs** (rough estimates):
- Image analysis: ~$0.01-0.02 per image
- Outfit generation: ~$0.02-0.05 per request
- Testing with 10 items + 5 outfit generations: ~$0.30-0.50

## What's Next? 🎯

Once everything works:

- [ ] Test with different types of clothing
- [ ] Try generating outfits for different occasions
- [ ] Check the AI descriptions in your database
- [ ] Share your app with friends for testing
- [ ] Customize the prompts (see `OpenAIService.swift`)
- [ ] Add more features (see `AI_INTEGRATION_README.md`)

## Need Help? 📚

Check these files for more details:
- `AI_INTEGRATION_README.md` - Complete documentation
- `EXAMPLE_API_RESPONSES.md` - See what AI responses look like
- `supabase_migration.sql` - Database migration details

## Security Reminder 🔒

**IMPORTANT**: Before deploying or sharing your code:
- [ ] Never commit your API key to git
- [ ] Add `Config.swift` to `.gitignore` (or use environment variables)
- [ ] Set up proper secrets management for production
- [ ] Monitor your API usage regularly

---

**You're all set!** 🎉 Start building your AI-powered wardrobe now!
