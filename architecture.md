# Fashion E-Commerce Application Architecture

## Overview
This document outlines the technical architecture and implementation plan for a Flutter-based Fashion E-Commerce Application targeting streetwear and minimalist clothing. The app will provide a seamless shopping experience with user authentication, product browsing, secure checkout, and admin management capabilities.

## Core Features
- **Onboarding Screen**: Brand showcase with identity and style presentation
- **Home Screen**: Banners for new arrivals and featured items
- **Product Catalog**: Browse products with images, descriptions, and prices
- **Wishlist**: Save favorite items for later
- **Secure Checkout**: Support for Cash on Delivery, GCash, and PayPal
- **Order Tracking & History**: Monitor order status and view past purchases
- **Admin Dashboard**: Manage products, inventory, and orders
- **Push Notifications**: Alerts for promotions, drops, and restocks

## App Architecture

### Folder Structure
```
lib/
├── main.dart
├── models/
│   ├── product.dart
│   ├── user.dart
│   ├── order.dart
│   ├── cart_item.dart
│   └── category.dart
├── screens/
│   ├── onboarding/
│   ├── home/
│   ├── catalog/
│   ├── product_details/
│   ├── wishlist/
│   ├── cart/
│   ├── checkout/
│   ├── order_history/
│   ├── order_details/
│   └── admin/
├── widgets/
│   ├── product_card.dart
│   ├── banner_carousel.dart
│   └── custom_button.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── payment_service.dart
│   └── notification_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── wishlist_provider.dart
│   └── product_provider.dart
├── utils/
│   ├── constants.dart
│   └── helpers.dart
└── config/
    └── app_config.dart
```

### Data Models

#### Product Model
```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final List<String> sizes;
  final List<String> colors;
  final int stock;
  final bool isFeatured;
  final DateTime createdAt;
}
```

#### User Model
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final bool isAdmin;
}
```

#### Order Model
```dart
class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final String status; // pending, confirmed, shipped, delivered
  final DateTime createdAt;
  final String paymentMethod;
  final String? trackingNumber;
}
```

#### CartItem Model
```dart
class CartItem {
  final String productId;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;
}
```

### Navigation Flow

```mermaid
graph TD
    A[App Launch] --> B{First Time?}
    B -->|Yes| C[Onboarding]
    B -->|No| D[Home]
    C --> D
    D --> E[Catalog]
    D --> F[Wishlist]
    D --> G[Cart]
    E --> H[Product Details]
    H --> I[Add to Cart]
    H --> J[Add to Wishlist]
    I --> G
    J --> F
    G --> K[Checkout]
    K --> L[Order Confirmation]
    L --> M[Order History]
    M --> N[Order Details]
    D --> O[Profile]
    O --> M
    O --> P{Is Admin?}
    P -->|Yes| Q[Admin Dashboard]
    Q --> R[Product Management]
    Q --> S[Order Management]
    Q --> T[Inventory Management]
```

### Required Dependencies
- `go_router`: Declarative routing
- `provider`: State management
- `http`: HTTP requests
- `cached_network_image`: Image caching
- `shared_preferences`: Local storage
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `firebase_messaging`: Push notifications
- `firebase_storage`: File storage
- `flutter_paypal`: PayPal integration
- `paymaya_flutter`: GCash integration
- `intl`: Date formatting
- `flutter_svg`: SVG support
- `carousel_slider`: Banner carousels
- `badges`: Notification badges

### UI/UX Design Concepts

#### Theme
- **Color Scheme**: Minimalist palette with black, white, and neutral tones
- **Typography**: Clean, modern fonts (e.g., Inter, Roboto)
- **Components**: Material Design 3 with custom fashion-focused styling

#### Screen Concepts
- **Onboarding**: 3-4 slides with high-quality fashion images and brand messaging
- **Home**: Hero banner carousel, category grid, featured products horizontal list
- **Catalog**: Grid/list toggle, filter sidebar, search functionality
- **Product Details**: Image gallery, size/color selectors, detailed specs
- **Wishlist**: Card-based layout with quick actions
- **Cart**: Editable items with quantity controls and totals
- **Checkout**: Multi-step form with payment method selection
- **Order Tracking**: Visual timeline with status updates
- **Admin Dashboard**: Tabbed interface with analytics and management tools

### State Management
Using Provider pattern with ChangeNotifier:

- **AuthProvider**: User authentication state
- **CartProvider**: Shopping cart management
- **WishlistProvider**: Saved items management
- **ProductProvider**: Product data and search
- **OrderProvider**: Order history and tracking

### Backend Integration
- **Platform**: Firebase (Firestore, Auth, Storage, Messaging)
- **Data Storage**: Firestore collections for users, products, orders
- **Authentication**: Firebase Auth with email/password and social logins
- **File Storage**: Firebase Storage for product images
- **Real-time Updates**: Firestore listeners for live data
- **Push Notifications**: Firebase Cloud Messaging

### Payment Integration
- **PayPal**: flutter_paypal package
- **GCash**: paymaya_flutter or custom integration
- **Cash on Delivery**: Manual order processing

### Security Considerations
- Secure API keys management
- Input validation and sanitization
- HTTPS for all network requests
- User data encryption
- Admin role verification

### Performance Optimizations
- Image caching and lazy loading
- Pagination for large lists
- Efficient state updates
- Background task handling
- Offline data caching

### Testing Strategy
- Unit tests for models and utilities
- Widget tests for UI components
- Integration tests for critical flows
- End-to-end testing for checkout process

### Deployment
- Android: Google Play Store
- iOS: Apple App Store
- CI/CD: GitHub Actions for automated builds
- Monitoring: Firebase Crashlytics

## Sprint 1 User Flows

### 1. User Accounts & Profile

**Customer Flow:**
1. Open app → see onboarding (brand identity)
2. Tap Sign Up → enter name, email, password, address → confirm
3. System validates inputs → account created → auto-login
4. User can log in next time with email + password
5. From profile screen → update info (name, address, password)
6. Save changes → success message shown

**Admin Flow:**
1. Open app → tap Admin Login
2. Enter email + password → verify against admin role
3. Redirected to Admin Dashboard

### 2. Product Catalog

**Customer Flow:**
1. From home screen → see banners (new arrivals, featured items)
2. Tap "Shop Now" → go to product catalog
3. Browse products (grid/list view with images, name, price)
4. Tap a product → view detailed info (description, price, stock, images)
5. Choose to add to cart, add to wishlist, or go back

**Admin Flow:**
1. Log in → dashboard → product management
2. View catalog list with stock count and product details

### 3. Wishlist

**Customer Flow:**
1. While browsing catalog → tap heart icon on product
2. Product saved into Wishlist
3. Go to Wishlist screen → view saved items
4. Tap product → open product details, option to Add to Cart
5. Tap Remove → item deleted from Wishlist

*(Admin has no Wishlist flow in Sprint 1.)*

### 4. Secure Checkout (Cash on Delivery in Sprint 1)

**Customer Flow:**
1. From catalog or wishlist → add product to cart
2. Open Cart → review items, quantities, and total price
3. Tap Checkout → confirm delivery address
4. Select payment method (COD first, later GCash/PayPal)
5. Tap Place Order → order saved in system
6. Confirmation screen → "Your order has been placed"
7. Order appears in Order History (basic tracking)

**Admin Flow (partial in Sprint 1):**
1. Log in → dashboard → view incoming orders
2. See order details (customer, items, total, address, payment method)

## Implementation Phases
1. **Phase 1**: Project setup, authentication, basic navigation
2. **Phase 2**: Product catalog, search, and details
3. **Phase 3**: Cart, wishlist, and checkout
4. **Phase 4**: Order management and tracking
5. **Phase 5**: Admin dashboard and push notifications
6. **Phase 6**: Testing, optimization, and deployment

## Next Steps
Review this architecture plan and provide feedback for refinements before proceeding to implementation.