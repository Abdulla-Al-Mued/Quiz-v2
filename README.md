### Data Storage and state management
- Questions stored in `assets/questions.json`
- Scores persisted locally using Hive database
- Automatic data migration and type-safe storage
- getx state management

## Getting Started

### Prerequisites
- Flutter SDK 3.16.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Abdulla-Al-Mued/Quiz-v2.git
   cd quiz_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

Core Features (MVP)
1. Home Screen
○ App title + “Start Quiz” button
○ “Leaderboard” button

2. Quiz Flow
○ Load questions from assets/questions.json
○ Support rendering of LaTeX/Math equations in both questions and
answers
○ Show 1 question at a time with 4 multiple‐choice answers
○ User taps to select an answer (lock once selected)

○ “Next” button to move to the next question
○ Progress indicator (e.g., Q2/10)
3. Results Screen

○ Final score out of total

○ Option to enter player name
○ Save score to local leaderboard
4. Leaderboard Screen
○ Show top scores (player name + score)
○ Sort by highest score first
○ Persistent storage (Hive)

Everything Is implemented except ci/cd, unit test and night mode
