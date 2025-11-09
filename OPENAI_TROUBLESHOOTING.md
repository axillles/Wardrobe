# OpenAI API Troubleshooting Guide

## Common Network Connection Errors

### Error: `nw_connection_copy_connected_local_endpoint_block_invoke [C8] Connection has no local endpoint`

This error typically occurs when there are issues with the OpenAI API configuration or network connectivity.

## Root Causes and Solutions

### 1. Missing or Invalid API Key

**Symptoms:**
- Network connection errors when sending fits
- Console messages about invalid API key

**Solution:**
1. Open `AIWardrobe/Sources/Config/Config.swift`
2. Replace `"YOUR_OPENAI_API_KEY_HERE"` with your actual OpenAI API key
3. Ensure your API key starts with `sk-`
4. Get your API key from: https://platform.openai.com/api-keys

**Example:**
```swift
static let openAIAPIKey = "sk-your-actual-api-key-here"
```

### 2. Network Connectivity Issues

**Symptoms:**
- Timeout errors
- Cannot connect to host errors

**Solutions:**
- Check your internet connection
- Ensure your device can reach OpenAI's servers
- Try again after a few minutes (temporary server issues)

### 3. API Key Permissions

**Symptoms:**
- 401 Unauthorized errors
- API error messages about permissions

**Solutions:**
- Verify your OpenAI account has sufficient credits
- Check that your API key has the necessary permissions
- Ensure your API key hasn't expired

### 4. Rate Limiting

**Symptoms:**
- 429 Too Many Requests errors
- Temporary API failures

**Solutions:**
- Wait a few minutes before trying again
- Consider upgrading your OpenAI plan for higher rate limits

## Improved Error Handling

The app now provides better error messages:

- **Invalid API Key**: "OpenAI API key is not configured. Please update your API key in Config.swift"
- **Network Issues**: "Cannot connect to OpenAI servers. Please check your API key and network."
- **Timeout**: "Request timed out. Please try again."
- **No Internet**: "No internet connection. Please check your network."

## Testing Your Configuration

1. Update your API key in `Config.swift`
2. Try adding a clothing item with an image
3. Check the console logs for detailed error information
4. The app will continue to work even if AI analysis fails, but you'll get better error messages

## Debug Console Messages

Look for these messages in your debug console:

- ✅ `OpenAI API request successful` - Everything is working
- ❌ `OpenAI API key is not configured` - Update your API key
- ❌ `OpenAI API key format is invalid` - Check your API key format
- 🌐 `Making OpenAI API request to: ...` - Request is being sent
- 📡 `OpenAI API response status: 200` - Successful response

## Fallback Behavior

If OpenAI API fails:
- The clothing item will still be added to your wardrobe
- AI analysis will be skipped
- You can manually add descriptions and tags
- Outfit generation may not work without AI descriptions

## Getting Help

If you continue to experience issues:

1. Check the debug console for specific error messages
2. Verify your API key is correct and has credits
3. Test your internet connection
4. Try with a different image or after some time

## API Key Security

**Important:** Never commit your actual API keys to version control. The Config.swift file should be updated locally with your real keys but not pushed to public repositories.