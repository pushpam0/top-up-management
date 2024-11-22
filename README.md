# Top-Up Management App

This Flutter app allows users to efficiently manage their top-up beneficiaries, explore available top-up options, and execute top-up transactions for their UAE phone numbers. It implements a clean architecture, state management using BLoC, and adheres to best practices in code quality and UI/UX design.

## Features

- View available top-up beneficiaries.
- Add up to 5 active top-up beneficiaries.
- Top-up options include AED 5, AED 10, AED 20, AED 30, AED 50, AED 75, AED 100.
- Verification status determines the monthly top-up limits:
    - Unverified users: AED 500 per month per beneficiary.
    - Verified users: AED 1,000 per month per beneficiary.
- A total top-up limit of AED 3,000 per month for all beneficiaries.
- AED 3 transaction fee for every top-up transaction.
- Validation for beneficiary nickname length and UAE phone number format.
- State management using BLoC.
- Unit and widget tests with 80%+ test coverage.

## Assumptions

1. Verification status is toggled using a switch in the app (mocked for simplicity).//if you toggle  data will be reset for maintaining the consistency
2. The backend HTTP service is mocked using a `MockRepository`.
3. All business logic is tested through unit and widget tests.
4. No backend API is required for this assessment.

## Project Structure
lib/ ├── core/ │ ├── utils/ │ │ ├── app_colors.dart # Centralized app colors │ │ ├── app_text_styles.dart # Centralized text styles │ │ └── validation_utils.dart # Utility functions for validation ├── data/ │ ├── models/ │ │ └── beneficiary.dart # Beneficiary model │ └── repositories/ │ └── mock_repository.dart # Mock repository simulating backend ├── presentation/ │ ├── blocs/ │ │ ├── top_up_bloc.dart # BLoC for managing state │ │ ├── top_up_event.dart # Events for the BLoC │ │ └── top_up_state.dart # States for the BLoC │ ├── pages/ │ │ └── home_page.dart # Main UI page │ └── widgets/ │ └── error_modal.dart # Modal for displaying errors ├── main.dart # Entry point of the app

## Setup Instructions

### Prerequisites

- Flutter SDK installed ([installation guide](https://flutter.dev/docs/get-started/install))
- A compatible editor such as VSCode or Android Studio

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/pushpam0/top-up-management.git
   cd top-up-management

2. Install dependencies:
   flutter pub get
3. Run the app:
   flutter run
4. To run the tests:
   flutter test
Unit and Widget Tests

    This project includes unit and widget tests to ensure robust functionality and maintainability. The test coverage is focused on:
    Top-Up BLoC:
    Validates state transitions based on various events.
    Ensures all acceptance criteria are met.
    Home Page Widget:
    Verifies UI elements, interactions, and behaviors.
    Ensures consistency with the app's functionality.

Screen Shots:
    <img width="384" alt="Screenshot 2024-11-22 at 2 15 23 PM" src="https://github.com/user-attachments/assets/72080403-57df-4b7f-8618-c2acba0a92e6">
    <img width="361" alt="Screenshot 2024-11-22 at 2 14 48 PM" src="https://github.com/user-attachments/assets/f522807f-f49b-4621-bc77-6608960e3455">
    <img width="361" alt="Screenshot 2024-11-22 at 2 14 20 PM" src="https://github.com/user-attachments/assets/31a48081-980b-4a4d-89d8-2a5720c4154e">
    <img width="360" alt="Screenshot 2024-11-22 at 2 14 03 PM" src="https://github.com/user-attachments/assets/0a0d4837-c1e0-48b6-b443-29002a25ec59">
    <img width="374" alt="Screenshot 2024-11-22 at 2 12 42 PM" src="https://github.com/user-attachments/assets/350ef465-b61c-47e4-9694-bc994809c0b8">
    <img width="372" alt="Screenshot 2024-11-22 at 2 11 25 PM" src="https://github.com/user-attachments/assets/a1a676ab-bb54-4004-a5b8-87cfe14804ac">
    <img width="389" alt="Screenshot 2024-11-22 at 2 11 11 PM" src="https://github.com/user-attachments/assets/d6935332-ac4b-4824-918c-d4832199818f">
    <img width="389" alt="Screenshot 2024-11-22 at 2 15 51 PM" src="https://github.com/user-attachments/assets/dba955a0-2a3c-4a79-9049-8f0cc2af2e8c">
    <img width="386" alt="Screenshot 2024-11-22 at 2 16 18 PM" src="https://github.com/user-attachments/assets/3af7006e-4164-47b5-8eaf-50ae1441ba14">
    <img width="379" alt="Screenshot 2024-11-22 at 2 17 32 PM" src="https://github.com/user-attachments/assets/e8404ca3-d50b-440b-8ec3-9560c7a27b26">












    
