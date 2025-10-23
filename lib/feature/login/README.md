# Login Feature

This feature implements Firebase Authentication with role-aware users (customer/admin) using Clean Architecture.

## Role Resolution

On every auth operation (login, register, getCurrentUser, updateProfile), the data source resolves the user's role in this order:

1. Firebase Custom Claims: expects a boolean `admin` claim set via Firebase Admin SDK.
2. Firestore fallback: reads `users/{uid}` document with a `role` field. Accepted values: `admin` or `customer` (default).

On registration and profile updates, a `users/{uid}` document is created/merged with basic profile fields and a default `role: 'customer'`.

## How to Grant Admin Role

Because setting custom claims requires administrative privileges, it must be done via server-side code (Admin SDK) or a Cloud Function. Below are two common approaches.

### 1) Cloud Function (Node.js) – HTTP callable

```js
// functions/index.js (Firebase Functions v2 or v1 equivalent)
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Example HTTPS function to set/unset the `admin` custom claim.
exports.setAdminClaim = functions.https.onCall(async (data, context) => {
  // Require that the caller is already an admin
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Must be authenticated.');
  const callerToken = await admin.auth().verifyIdToken(context.auth.token.uid);
  if (!callerToken.admin) throw new functions.https.HttpsError('permission-denied', 'Admin privilege required.');

  const { uid, isAdmin } = data; // isAdmin: true/false
  await admin.auth().setCustomUserClaims(uid, { admin: !!isAdmin });
  return { ok: true };
});
```

Client-side, after calling the function, force refresh the ID token:

```dart
await FirebaseAuth.instance.currentUser?.getIdToken(true);
```

### 2) Firestore Fallback

Store a document at `users/{uid}` with a `role` field:

```json
{
  "id": "<uid>",
  "name": "Alice",
  "email": "alice@example.com",
  "role": "admin" // or "customer"
}
```

The app will treat `role: 'admin'` as admin when no custom claim is present.

## Files

- `data/models/user_model.dart`: DTO extending the domain `User` entity.
- `data/datasources/auth_remote_data_source.dart`: Interface for remote operations.
- `data/datasources/auth_remote_data_source_impl.dart`: FirebaseAuth + Firestore implementation with role resolution.
- `data/repositories/auth_repository_impl.dart`: Bridges data source to domain repository using Either/Failure.

## Usage in UI

- Access the role via `user.role` (enum). Example: `if (user.role == UserRole.admin) { /* show admin UI */ }`.
- Call `getCurrentUser()` on app start to determine initial auth state and role.

## Notes

- Changing email requires recent authentication; the current implementation avoids updating email silently to prevent errors. Add a re-auth flow before calling `updateEmail`.
- Ensure `firebase_core`, `firebase_auth`, and `cloud_firestore` are configured in your app.
