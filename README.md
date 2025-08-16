### Data Storage
- Questions stored in `assets/questions.json`
- Scores persisted locally using Hive database
- Automatic data migration and type-safe storage

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

Everything Is implemented except ci/cd, unit test and night mode
