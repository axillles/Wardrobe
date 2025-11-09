-- Migration: Add AI description support to clothing_items table
-- Run this in your Supabase SQL Editor: https://supabase.com/dashboard/project/_/sql

-- Add ai_description column to store JSON metadata from OpenAI analysis
ALTER TABLE clothing_items
ADD COLUMN IF NOT EXISTS ai_description TEXT;

-- Add comment to document the column purpose
COMMENT ON COLUMN clothing_items.ai_description IS 'JSON string containing AI-generated clothing description from OpenAI Vision API';

-- Optional: Create an index for faster queries if you plan to search within descriptions
-- CREATE INDEX IF NOT EXISTS idx_clothing_items_ai_description ON clothing_items USING gin (to_tsvector('english', ai_description));

-- Verify the migration
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'clothing_items'
ORDER BY ordinal_position;
