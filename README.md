🫁 **Breathing App** — NewU Hackathon Assignment
A Flutter breathing exercise app built for mobile and web as part of the NewU hackathon assignment.
Live Web App: https://breathingnewu.netlify.app/
GitHub: https://github.com/Iamirshad94/breathing_new_app (branch: feature_dev_V_1_0)

✨ **Features**

Guided breathing sessions — configurable inhale, hold, exhale phases with smooth bubble animation
Customisable settings — breath duration (3–6s), rounds (2/4/6/8), advanced per-phase timing
Sound support — chime plays after each completed cycle
Light & dark mode — manual toggle with full theme support
Pause & resume — freezes animation, timer, and progress mid-session
Responsive layout — works seamlessly on mobile and web


🏗️ **Architecture**
Clean Architecture with feature-based folder structure.
lib/
  core/
    theme/
      app_colors.dart             # All color constants for light/dark
      app_theme.dart              # ThemeData for light and dark mode
      dark_mode_scope.dart        # InheritedWidget scope for dark mode
      dark_mode_storage.dart      # Persists dark mode preference
    utils/
      asset_paths.dart            # All SVG asset path constants
      chime_player.dart           # Abstract chime player interface
      chime_player_impl.dart      # Real audio implementation
      chime_player_stub.dart      # Web/stub implementation
      constants.dart              # Timing values, default settings
      enums.dart                  # BreathingPhase, RoundOption enums
      size_utils.dart             # Responsive size helpers
    widgets/
      layout_scope.dart           # Layout information scope
      responsive_layout.dart      # Mobile/web layout switcher
  features/
    breathing/
      domain/
        entities/
          breathing_session.dart  # Session entity
          session_config.dart     # Session configuration model
        usecases/
          start_session_usecase.dart
          complete_session_usecase.dart
      presentation/
        bloc/
          breathing_bloc.dart     # Session state machine
          breathing_event.dart    # Start, Tick, Pause, Resume, Cancel
          breathing_state.dart    # InProgress, Paused, Complete
        screens/
          initial_setting_screen.dart  # Settings/home screen
          breathing_screen.dart        # Active session screen
          success_screen.dart          # Completion screen
        widgets/                       # All reusable UI components
  main.dart

🧱 **Tech Stack**
PackagePurposeflutter_blocState managementequatableValue equality for Bloc statesflutter_svgSVG asset renderinggoogle_fontsNunito fontjust_audioChime sound after each cyclegapConsistent spacingbloc_testBloc unit testsmocktailMocking in tests

🫧 **Breathing Logic**
Each session consists of N cycles. Every cycle has 4 phases:
PhaseBubbleCounterBreathe InExpandsCounts upHold InStays sameNothing shownBreathe OutShrinksCounts downHold OutStays sameNothing shown
A Timer.periodic ticks every second and drives both the counter and AnimationController. When paused, the timer is cancelled and the animation controller is stopped. On resume, both restart from the saved position.

📱 **Screens**
Pace Screen (pace_screen.dart)

Breath duration selector (3s / 4s / 5s / 6s)
Round selector (2 quick / 4 calm / 6 deep / 8 zen)
Sound toggle
Advanced timing panel (per-phase duration control)
Dark mode toggle
Start breathing button

**Breathing Screen (breathing_screen.dart)**

Animated bubble with phase counter
Phase label (Breathe in / Hold gently / Breathe out / Hold softly)
Session progress bar
Cycle indicator (Cycle X of Y)
Pause / Resume button
Cancel button

**Result Screen (result_screen.dart)**

Success SVG animation
Start again button
Back to set up button


🌐 **Web Support**
Single Flutter codebase targeting both mobile and web. responsive_layout.dart uses LayoutBuilder to switch layouts:

Mobile (<600px) — full width, standard sizing
Web (≥600px) — max width 480px, horizontally centered

Chime audio uses a stub/impl pattern (chime_player.dart / chime_player_impl.dart / chime_player_stub.dart) to handle platform differences between mobile and web.

🚀 **Getting Started**
bash# Install dependencies
flutter pub get

# Run on mobile
flutter run

# Run on web
flutter run -d chrome

# Build web
flutter build web --release

👨‍💻 **Author**
Built by Irshad — GitHub
