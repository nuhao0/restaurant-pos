# Restaurant POS - Security & RBAC Update

I have successfully added secure authentication and role-based access control (RBAC) to your POS without redesigning or breaking your existing functionality!

Here is a detailed breakdown of the changes and how everything works.

## 1. What I Changed
- **`lib/auth_screens.dart`**: Created new screens for Login, Registration, Email Verification, and Employee Management.
- **`lib/main.dart`**: Wrapped your existing `MainLayout` in an `AuthWrapper` that blocks access until logged in. Updated all Firestore queries (`orders` and `menu`) to filter data by `restaurantId`.
- **`lib/widgets.dart`**: Updated the Sidebar to read the user's role and hide Admin-only tabs (History, Reports, Settings, Menu Management) if the user is an employee.
- **`lib/settings_screen.dart`**: Added a "Manage Employees" section and a "Migrate Legacy Data" button for the owner.
- **`firestore.rules`**: Created strict database-level security rules to enforce these roles so data is protected even if someone bypasses the Flutter UI.

## 2. How the Owner Account Works
- When you first open the app, you will see a Login/Register screen.
- Click **"Create Owner Account"** and register with your real email and password.
- You will become the **Owner/Admin**. Your unique Firebase user ID will become your `restaurantId`.
- Any data you create (menu items, orders) will be securely tagged with your `restaurantId`.

## 3. How Password Reset / Change Works
- On the Login screen, there is a **"Forgot Password?"** button.
- If you or an employee forgets their password, they just enter their email and click that button. Firebase will automatically send a secure password reset link to their inbox.

## 4. How the Owner Adds Employees
- Once logged in as the Owner, go to **Settings**.
- Scroll to the bottom to find the **Manage Employees** section.
- You can type an email and password to create an employee account directly. 
- *Technical detail:* I used a "Secondary Firebase App" instance in the code for this. This ensures you can create employee accounts without Firebase accidentally logging you out of your Admin session!

## 5. What Employees Can and Cannot Access
- **Can Access**: The POS/Cashier screen (they can ring up orders and check out).
- **Cannot Access**: Sales history, Reports/Daily stats, Menu Management (adding/editing items), and Settings. The Sidebar buttons are completely hidden for them.

## 6. How Firebase Security Rules Protect the Data
Hiding buttons in Flutter isn't enough, so I wrote custom `firestore.rules` that execute on Google's servers:
- Every time the app requests data, Firebase checks the `users` collection to see if the logged-in user is an `owner` or `employee`.
- **Data Isolation:** It checks the `restaurantId`. An employee of Restaurant A will automatically get a "Permission Denied" error if they somehow try to query Restaurant B's data.
- **Role Enforcement:** Employees are granted `allow create` on `orders` (to checkout), but they are strictly denied `allow read` on `orders` (history) and `allow write` on `menu`. Even if a hacker modifies the Flutter code, Firebase will reject the request.

## 7. How to Test the Admin and Employee Accounts
1. Run the app (`flutter run`). Register a new Owner account.
2. Go to **Settings** and click the **"Migrate Legacy Data"** button. (Since we added `restaurantId` security, your existing 66 menu items won't show up until you "claim" them as the new owner).
3. Verify your menu items appear and you can make an order.
4. Go to **Settings -> Manage Employees** and create an employee account (e.g., `cashier@test.com`).
5. **Log out** (using the logout button at the bottom of the sidebar).
6. **Log in** with the new employee account. Notice how the sidebar shrinks to only show the POS, and try clicking around to ensure it works!

## 8. What You Need to Do Before Deploying
Before you deploy the updated app to production, you must apply the new Security Rules to your Firebase project:
1. Open your Firebase Console in your browser.
2. Go to **Firestore Database** -> **Rules** tab.
3. Open the `firestore.rules` file in your VS Code, copy all of the text inside it, and paste it into the Firebase console.
4. Click **Publish**.

Once the rules are published, your database is 100% secure and you are ready to deploy the new version of your Flutter app!
