# Registration Flow Documentation

## Overview

The app now features a modern, multi-step registration flow that collects user preferences before account creation. This follows a clean Apple design aesthetic with smooth transitions and intuitive controls.

## Registration Steps

### 1. **Basic Info** (Step 1 of 4)
- **Purpose**: Collect physical measurements for personalized recommendations
- **Fields**:
  - Height (cm) - Custom wheel picker, range: 140-220 cm
  - Weight (kg) - Custom wheel picker, range: 40-150 kg
  - Age (years) - Custom wheel picker, range: 13-100 years
- **Design**: Clean card-based layout with integrated wheel pickers
- **Validation**: All three fields must be filled to continue

### 2. **Style Preferences** (Step 2 of 4)
- **Purpose**: Identify user's fashion style preferences
- **Available Styles**:
  - Casual
  - Formal
  - Sporty
  - Elegant
  - Streetwear
  - Minimalist
  - Bohemian
  - Vintage
- **Design**: 2-column grid with icon-based cards
- **Interaction**: Multi-select (tap to toggle)
- **Visual Feedback**: Selected cards turn black with white text
- **Validation**: At least one style must be selected

### 3. **Color Preferences** (Step 3 of 4)
- **Purpose**: Capture user's preferred wardrobe colors
- **Available Colors**:
  - Black, White, Gray
  - Navy, Blue
  - Red, Pink, Purple
  - Green, Olive
  - Brown, Beige
  - Yellow, Orange
  - Burgundy
- **Design**: 3-column grid with circular color swatches
- **Interaction**: Multi-select with checkmark indicators
- **Visual Feedback**: Black border + checkmark on selected colors
- **Validation**: At least one color must be selected

### 4. **Authentication** (Step 4 of 4)
- **Purpose**: Create user account
- **Fields**:
  - Email (with email keyboard)
  - Password (secure field)
  - Confirm Password (secure field)
- **Validation**:
  - Email must not be empty
  - Password minimum 6 characters
  - Passwords must match
- **Note**: User profile data ready to save to database upon signup

## Navigation Features

### Progress Bar
- Visual indicator at the top showing completion progress
- Smoothly animates as user progresses through steps
- 25% increment per step

### Back Button
- Available on steps 2-4
- Returns to previous step while preserving entered data
- Consistent gray button design

### Continue/Sign Up Button
- Primary black button
- Disabled state when validation fails (50% opacity)
- Loading state on final authentication step

### Sign In Option
- "Sign In" button available on the first step (top right)
- Opens modal sheet for existing users
- Clean, simple login form

## File Structure

```
Sources/
├── Models/
│   └── UserProfile.swift           # User profile data model
├── Coordinators/
│   └── RegistrationCoordinator.swift # Registration state management
├── Views/
│   ├── Registration/
│   │   ├── RegistrationFlowView.swift      # Main container
│   │   ├── BasicInfoStepView.swift         # Step 1
│   │   ├── StylePreferencesStepView.swift  # Step 2
│   │   ├── ColorPreferencesStepView.swift  # Step 3
│   │   ├── AuthenticationStepView.swift    # Step 4
│   │   └── SignInView.swift                # Login for existing users
│   └── Components/
│       └── MeasurementPicker.swift         # Custom wheel pickers
```

## User Profile Model

```swift
struct UserProfile {
    let userId: UUID
    var height: Int?        // in cm
    var weight: Int?        // in kg
    var age: Int?
    var preferredStyles: [StylePreference]
    var preferredColors: [String]
    var measurementUnit: MeasurementUnit
}
```

## Design Principles

### Visual Style
- **Typography**: SF Pro system font with varied weights
- **Colors**: Black/white theme with gray accents
- **Spacing**: Generous padding (24-40px) for breathing room
- **Corners**: Rounded (12-20px) for modern feel
- **Cards**: Light gray backgrounds with subtle borders

### Interactions
- **Smooth Transitions**: Slide + fade between steps
- **Haptic Feedback**: Implicit through button interactions
- **Multi-Select**: Clear visual states (selected/unselected)
- **Validation**: Real-time with visual feedback

### Accessibility
- **Large Touch Targets**: Minimum 44pt for all interactive elements
- **Clear Labels**: Descriptive headers and instructions
- **Color Contrast**: WCAG compliant
- **Wheel Pickers**: Native iOS controls for accessibility

## Integration Notes

### Database Integration (TODO)
The `AuthenticationStepView` includes a TODO comment where the user profile should be saved to the database after successful signup:

```swift
if viewModel.isAuthenticated {
    // TODO: Save user profile to database
    appCoordinator.loginCompleted()
}
```

To complete this:
1. Add a `user_profiles` table to Supabase
2. Create service method to save profile
3. Call it before `loginCompleted()`

### Recommended Database Schema

```sql
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    height INT,
    weight INT,
    age INT,
    preferred_styles TEXT[],
    preferred_colors TEXT[],
    measurement_unit TEXT DEFAULT 'metric',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own profile"
    ON user_profiles FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own profile"
    ON user_profiles FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile"
    ON user_profiles FOR UPDATE
    USING (auth.uid() = user_id);
```

## Testing Checklist

- [ ] Basic info validation works (all fields required)
- [ ] Style preferences multi-select toggles correctly
- [ ] Color preferences multi-select toggles correctly
- [ ] Back button preserves previously entered data
- [ ] Progress bar animates correctly
- [ ] Continue button disables when validation fails
- [ ] Sign In modal opens and closes properly
- [ ] Email/password validation works
- [ ] Authentication successful flow transitions to main app
- [ ] All transitions are smooth and performant

## Future Enhancements

1. **Imperial Units Support**: Add toggle for lbs/inches
2. **Profile Editing**: Allow users to update preferences later
3. **Skip Options**: Let users skip optional steps
4. **Social Login**: Add Apple/Google sign-in
5. **Password Strength**: Visual indicator for password strength
6. **Profile Photos**: Add avatar upload in registration
7. **Onboarding Tips**: Add contextual help for each step
