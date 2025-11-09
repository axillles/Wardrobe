# AIWardrobe Database Setup Guide

## 1. Supabase Configuration

### Setting up your API keys

1. Go to your [Supabase Dashboard](https://app.supabase.com)
2. Create a new project or select an existing one
3. Navigate to **Project Settings** → **API**
4. Copy your **Project URL** and **anon/public key**
5. Open `AIWardrobe/Sources/Utilities/Config.swift`
6. Replace the placeholder values:

```swift
enum Config {
    static let supabaseURL = "https://your-project-id.supabase.co"
    static let supabaseAnonKey = "your-anon-key-here"
}
```

⚠️ **Important**: Never commit real API keys to version control. Consider using environment variables or `.xcconfig` files for production.

---

## 2. Database Tables Setup

Go to your Supabase Dashboard → **SQL Editor** and run the following SQL commands:

### Table 1: clothing_items

```sql
-- Create clothing_items table
CREATE TABLE clothing_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    category TEXT NOT NULL,
    color TEXT,
    brand TEXT,
    season TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX idx_clothing_items_user_id ON clothing_items(user_id);
CREATE INDEX idx_clothing_items_category ON clothing_items(category);

-- Enable Row Level Security (RLS)
ALTER TABLE clothing_items ENABLE ROW LEVEL SECURITY;

-- Create policies for RLS
CREATE POLICY "Users can view their own clothing items"
    ON clothing_items FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own clothing items"
    ON clothing_items FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own clothing items"
    ON clothing_items FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own clothing items"
    ON clothing_items FOR DELETE
    USING (auth.uid() = user_id);
```

### Table 2: outfits

```sql
-- Create outfits table
CREATE TABLE outfits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    items UUID[] NOT NULL, -- Array of clothing_item IDs
    occasion TEXT,
    ai_generated BOOLEAN DEFAULT false,
    is_favorite BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX idx_outfits_user_id ON outfits(user_id);

-- Enable Row Level Security (RLS)
ALTER TABLE outfits ENABLE ROW LEVEL SECURITY;

-- Create policies for RLS
CREATE POLICY "Users can view their own outfits"
    ON outfits FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own outfits"
    ON outfits FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own outfits"
    ON outfits FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own outfits"
    ON outfits FOR DELETE
    USING (auth.uid() = user_id);
```

---

## 3. Storage Bucket Setup

The app needs a storage bucket for clothing item images.

1. Go to **Storage** in your Supabase Dashboard
2. Click **Create a new bucket**
3. Name it: `wardrobe-images`
4. Make it **Public** (so images can be accessed)
5. Click **Create bucket**

### Storage Policies

Run this SQL to set up storage policies:

```sql
-- Allow authenticated users to upload images
CREATE POLICY "Users can upload images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'wardrobe-images' 
    AND auth.role() = 'authenticated'
);

-- Allow authenticated users to update their images
CREATE POLICY "Users can update their images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'wardrobe-images' 
    AND auth.role() = 'authenticated'
);

-- Allow authenticated users to delete their images
CREATE POLICY "Users can delete their images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'wardrobe-images' 
    AND auth.role() = 'authenticated'
);

-- Allow public read access to images
CREATE POLICY "Public can view images"
ON storage.objects FOR SELECT
USING (bucket_id = 'wardrobe-images');
```

---

## 4. Authentication Setup

Authentication is already enabled by default in Supabase. To configure it:

1. Go to **Authentication** → **Providers** in your Supabase Dashboard
2. Enable **Email** authentication (should be on by default)
3. Optional: Configure email templates under **Authentication** → **Email Templates**

---

## 5. Verification Checklist

After setup, verify:

- ✅ `clothing_items` table exists with RLS policies
- ✅ `outfits` table exists with RLS policies
- ✅ `wardrobe-images` storage bucket exists with policies
- ✅ Email authentication is enabled
- ✅ Config.swift has your actual Supabase URL and anon key

---

## 6. Database Schema Diagram

```
┌─────────────────────────┐
│   auth.users (Supabase) │
│   - id (UUID)           │
│   - email               │
└────────────┬────────────┘
             │
             │ user_id (FK)
             │
    ┌────────┴──────────┐
    │                   │
    ▼                   ▼
┌─────────────────┐  ┌──────────────┐
│ clothing_items  │  │   outfits    │
├─────────────────┤  ├──────────────┤
│ id (PK)         │  │ id (PK)      │
│ user_id (FK)    │  │ user_id (FK) │
│ image_url       │  │ name         │
│ category        │  │ items[]      │──┐
│ color           │  │ occasion     │  │
│ brand           │  │ ai_generated │  │
│ season          │  │ is_favorite  │  │
│ created_at      │  │ created_at   │  │
└─────────────────┘  └──────────────┘  │
                                        │
                         References ────┘
                         clothing_items.id[]
```

---

## Troubleshooting

### Error: "User not authenticated"
- Make sure you've signed up/signed in through the app
- Check that RLS policies are correctly set up

### Error: "relation does not exist"
- Verify tables were created successfully
- Check table names match exactly (case-sensitive)

### Images not uploading
- Verify the `wardrobe-images` bucket exists
- Check storage policies are set up correctly
- Ensure bucket is set to public

### Can't connect to Supabase
- Double-check your URL and anon key in Config.swift
- Verify your Supabase project is active
- Check your internet connection
