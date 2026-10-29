# ResumeCraft - Android-Only Resume Maker in Flutter & Dart

**ResumeCraft** is a complete, modern, production-grade mobile application built exclusively for Android devices using **Flutter**, **Dart**, and **Material 3**. It empowers students, fresh graduates, professionals, and executives to design, customize, verify against ATS scanners, preview, and export high-impact resumes and CVs directly from their Android device.

---

## Key Features

1. **Complete Mobile Flow**:
   - **Splash Screen**: Animated document branding with glowing pulse and version tagline.
   - **Onboarding Carousel**: 3-step PageView with smooth animated indicators, badges, and skip/start actions.
   - **Authentication**: Login, Sign Up, and Forgot Password (email -> OTP -> reset) with Guest mode option.
   - **Home Dashboard**: Dynamic time-based greeting ("Good morning, Alex!"), quick stats, "+ Create New Resume" CTA, "Continue Editing" card with live progress bar, recent resumes, and ATS scan banner.
   - **Bottom Navigation**: 5-tab Material 3 NavigationBar (`Home`, `Resumes`, `Templates`, `Tips`, `Profile`) with Android system back-gesture protection via `PopScope`.

2. **Multi-Step Resume Builder (10 Steps)**:
   - **Autosave Engine**: Instant debounced local persistence with status indicators ("Saved just now" / "Saving...").
   - **1. Personal Information**: Full contact links, location, and photo picker (gallery/camera/presets).
   - **2. Professional Summary**: Multiline editor with AI writing triggers (`Generate with AI`, `Make Professional`, `Make ATS Friendly`, `Shorten`), word & character counters.
   - **3. Work Experience**: Expandable cards, reordering handles, "Currently Working Here" toggle, AI-generated quantifiable achievements.
   - **4. Education**: Degrees, institutions, GPA, dates, and honors.
   - **5. Skills**: Search, smart role-based recommendations, custom skills, and proficiency sliders (Beginner to Expert).
   - **6. Projects**: Project titles, roles, tech stack tags, descriptions, and URLs.
   - **7. Certifications**: Issuer, credential IDs, expiration dates, and verification links.
   - **8. Languages**: Language names with CEFR / proficiency dropdowns.
   - **9. References**: Referee contacts with "Do not include references" toggle.
   - **10. Finish & Checklist**: Completion percentage calculator and section verification list.

3. **Live Resume Preview & Customization Engine**:
   - High-fidelity Flutter widget renderer supporting **Single-Column** and **Two-Column** layouts.
   - Pinch-to-zoom interactive canvas with zoom controls and page counter.
   - Real-time customization sheet:
     - 6 curated palettes (Royal Blue, Executive Navy, Classic Noir, Slate Gray, Emerald Green, Burgundy).
     - Typography font switcher (Roboto, Inter, Georgia, Courier).
     - Layout density (One Column, Two Column, Compact, Spacious).
     - Drag/toggle section visibility.

4. **ATS Compatibility Checker & Job Description Matching**:
   - Radial ATS compatibility score (0-100%).
   - Evaluation breakdown across Contact Info, Keywords, Experience Metrics, Skills Density, and Formatting.
   - Paste custom job descriptions to calculate match %, identify missing keywords, and view 1-tap improvements.

5. **Conversational AI Resume Assistant**:
   - Bottom sheet chat assistant with quick-prompt pills.
   - Instant offline-first contextual generation.
   - Fully editable output with 1-tap "Insert into Summary", "Copy", and "Regenerate".

6. **Vectorized PDF Generation & Android Native Share**:
   - Client-side multi-page PDF generation using `pdf` and `printing` packages.
   - Standard A4 and US Letter format support.
   - Settings toggles: Include Photo, Clickable Links, PDF Compression.
   - Android native share sheet integration (`ShareService`).

7. **My Resumes & Templates Showcase**:
   - Filterable & searchable card list with thumbnail, last edited date, completion %.
   - 3-dot context menu: Edit, Preview, Rename dialog, Duplicate, Download PDF, Share, and Delete confirmation dialog.
   - Template gallery with 7+ curated styles and category filter chips.

8. **Career Tips & User Profile**:
   - 6 detailed recruiter-tested advice guides (Google's X-Y-Z formula, ATS secrets, 1 vs 2 page rules).
   - Light, Dark, and System Default theme support.
   - Free vs Pro comparison cards with annual/monthly billing toggles.

---

## Project Structure

```text
lib/
├── main.dart                          # Application entrypoint & multi-provider initialization
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Material 3 color tokens & resume palettes
│   │   ├── app_strings.dart           # App strings & step labels
│   │   └── app_assets.dart            # Avatar presets & icon definitions
│   ├── theme/
│   │   ├── app_theme.dart             # Material 3 Light & Dark ThemeData
│   │   └── color_schemes.dart         # ColorScheme definitions
│   ├── utils/
│   │   ├── date_formatter.dart        # Month/Year & date range formatters
│   │   ├── validators.dart            # Form input validators
│   │   └── responsive_layout.dart     # Responsive layout helper
│   └── widgets/
│       ├── custom_button.dart         # Primary, secondary, outline, icon buttons
│       ├── custom_text_field.dart     # Material 3 inputs with password/counter support
│       ├── app_card.dart              # Rounded cards with elevation
│       ├── step_progress_bar.dart     # Progress bar with autosave indicator
│       ├── section_header.dart        # Section headers with add triggers
│       ├── empty_state_view.dart      # Empty state views with CTAs
│       ├── skeleton_loader.dart       # Shimmer placeholder loaders
│       └── confirmation_dialog.dart   # Modals for destructive actions
│
├── models/
│   ├── resume_model.dart              # Master Resume model & PersonalInfo
│   ├── experience_model.dart          # WorkExperience
│   ├── education_model.dart           # Education
│   ├── skill_model.dart               # Skill & SkillLevel
│   ├── project_model.dart             # Project
│   ├── certification_model.dart       # Certification
│   ├── language_model.dart            # Language & LanguageProficiency
│   ├── reference_model.dart           # Reference
│   ├── template_model.dart            # ResumeTemplate & CustomizationConfig
│   └── ats_result_model.dart          # ATS & Job Matching models
│
├── services/
│   ├── storage_service.dart           # SharedPreferences & JSON persistence
│   ├── pdf_service.dart               # Multi-page PDF layout & document generator
│   ├── share_service.dart             # Android share sheet integration
│   ├── ai_service.dart                # AI prompt & rewrite engine
│   ├── ats_service.dart               # ATS scoring & keyword analyzer
│   └── template_service.dart          # Curated resume templates catalog
│
├── providers/
│   ├── resume_provider.dart           # Active resume editing & autosave debounce
│   ├── resume_list_provider.dart      # Saved resumes collection & search
│   ├── theme_provider.dart            # Light / Dark / System mode
│   └── auth_provider.dart             # User profile, login, guest, and pro tier
│
└── screens/
    ├── splash/                        # Animated splash screen
    ├── onboarding/                    # 3-step onboarding PageView
    ├── auth/                          # Login, Signup, Forgot Password
    ├── home/                          # Main navigation shell & dashboard
    ├── resumes/                       # My Resumes list, search & popup menu
    ├── templates/                     # Templates gallery & full-screen preview
    ├── builder/                       # Multi-step resume builder (10 steps)
    ├── preview/                       # Live zoomable preview & canvas renderer
    ├── customization/                 # Bottom sheet style customizer
    ├── ats/                           # ATS score & Job description matcher
    ├── ai/                            # AI Resume Assistant conversational sheet
    ├── export/                        # A4/Letter PDF exporter & share dialog
    ├── tips/                          # Career advice articles & detail sheet
    └── profile/                       # Profile, settings & Pro upgrade
```

---

## Running the Application

1. Ensure you have Flutter 3.10+ installed on your system.
2. Clone or open this repository:
   ```bash
   cd c:/Users/ENDUSER/Mobile
   ```
3. Fetch Flutter dependencies:
   ```bash
   flutter pub get
   ```
4. Run on an Android emulator or connected device:
   ```bash
   flutter run
   ```
