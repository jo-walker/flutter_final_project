# Team Project Instructions and Structure

Welcome to our team project! This guide will help you set up the project, work on your parts, and use GitHub for version control. Let's get started!

## Project Structure

To keep our project simple and easy to understand, we will use the following structure:

lib/
    main.dart
    customer.dart
    airplane.dart
    flight.dart
    reservation.dart
    pages/
        customer_page.dart
        airplane_page.dart
        flight_page.dart
        reservation_page.dart


### File Responsibilities

- **Combined Model and Provider**: Each feature (Customer, Airplane, Flight, Reservation) will have a single file that includes both the model and the provider.
- **Single Page File**: Each feature will have a single file for the UI, handling both the list view and the form view.

## Setting Up the Project

1. **Clone the Repository**: Start by cloning the repository to your local machine. Open your terminal or command prompt and run:
   ```sh
   git clone <repository-url>
   ```
    Replace <repository-url> with the URL of the GitHub repository.
2. **Open the Project**: Open the project in your preferred code editor (e.g., Android Studio).


## Working on Your Part
### 1. Create a New Branch
Before you start working on your part, create a new branch for your changes. This will help you keep your changes separate from the main branch and make it easier to merge them later.
    
    ```sh
    git checkout -b <branch-name>
    ```
    Replace <branch-name> with a descriptive name for your branch (e.g., feature/airplane).
2. **Work on Your Part**: Implement the required functionality for your part (Customer, Airplane, Flight, Reservation).
3. **Add Your Routes in main.dart**:
   Ensure your page is routed correctly in main.dart. Add an entry to the routes map like this:
    ```dart
    routes: {
   '/': (context) => MainPage(),
   '/customer': (context) => CustomerListPage(),
   '/airplane': (context) => AirplaneListPage(),
   '/flight': (context) => FlightsListPage(),
   '/reservation': (context) => ReservationPage(),
   },
    ```
    Replace the route path and page with the appropriate values for your part.

4. **Commit Your Changes**: Once you have made some progress, commit your changes to the branch.
    ```sh
    git add .
    git commit -m "Your commit message"
   git push origin <branch-name>
    ```
    Replace "Your commit message" with a brief description of the changes you made.
    replace <branch-name> with the name of your branch.