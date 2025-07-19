# 🍽️ Foodie Spot

**Foodie Spot** is a clean, responsive Flutter app (v3.32.4) developed using Android Studio (Koala), designed to help users discover restaurants and food items based on their location, preferences, and popularity. This project fully satisfies the given task requirements including fetching from public APIs, state management, filtering, UI precision, and responsive design (mobile & web).

---

## ✨ Features Overview

- ✅ **Splash Screen** – Clean branding intro  
- ✅ **Dashboard UI** – Central navigation hub *(📷 add screenshot here)*  
- ✅ **Restaurant & Food Search** – Search by name or keyword *(📷 add screenshot)*  
- ✅ **Product & Restaurant Description** – Detail views with images, ratings *(📷 add screenshot)*  
- ✅ **Category Screen** – All food categories via `/categories` endpoint  
- ✅ **Popular Nearby Foods** – Show data from `/products/popular`  
- ✅ **Food Campaign Page** – Pulls campaign items from `/campaigns/item`  
- ✅ **Restaurant List with Pagination** – Uses `/restaurants/get-restaurants/all`  
- ✅ **Filter & Sorting** – Filter restaurants by distance, rating, cuisine, etc.  
- ✅ **Responsive UI** – Fully adaptive for both mobile and web  
- ✅ **Error Handling** – Handles no connection, loading errors, API fails  
- ✅ **State Management** – Uses [your state management solution here, e.g., Provider, Bloc]

---

## 🔗 API Endpoints Used

| Feature               | Endpoint                                              |
|----------------------|-------------------------------------------------------|
| Configuration        | `/api/v1/config`                                      |
| Banners              | `/api/v1/banners`                                     |
| Categories           | `/api/v1/categories`                                  |
| Popular Foods        | `/api/v1/products/popular`                            |
| Food Campaigns       | `/api/v1/campaigns/item`                              |
| Restaurants (Paginated) | `/api/v1/restaurants/get-restaurants/all?offset=1&limit=10` |

All API calls include the following headers:

```json
{
  "Content-Type": "application/json; charset=UTF-8",
  "zoneId": "[1]",
  "latitude": "23.735129",
  "longitude": "90.425614"
}
```

---

## 💻 UI Previews

📷 Replace these placeholder lines with actual image links:

- `![Splash & Dashboard](assets/screenshots/splash_dashboard.png)`
- `![Search & Details](assets/screenshots/search_detail.png)`
- `![Categories & Nearby](assets/screenshots/categories_nearby.png)`
- `![Campaign & Filter](assets/screenshots/campaign_filter.png)`

---

## ⚙️ Getting Started

### 1️⃣ Clone Repository

```bash
git clone https://github.com/IftikharSikder/foodie-spot.git
cd foodie-spot
```

### 2️⃣ Install Packages

```bash
flutter pub get
```

### 3️⃣ Run App

```bash
flutter run
```

Ensure you are running Flutter version **3.32.4** with Android Studio **Koala**.

---

## 🧠 Code Structure (Key Folders)

```
lib/
├── main.dart
├── screens/
│   ├── splash/
│   ├── dashboard/
│   ├── category/
│   ├── campaign/
│   ├── product_detail/
├── widgets/
├── services/     # API handling
├── models/       # Data models
├── providers/    # State management (e.g., Provider, Bloc)
```

---

## ✅ Job Task Checklist

| Requirement                                  | Implemented |
|---------------------------------------------|-------------|
| Flutter + Clean Code + State Management     | ✅           |
| Fetch data from public API                  | ✅           |
| Display in scrollable lists                 | ✅           |
| Pixel-perfect UI (Mobile & Web Responsive)  | ✅           |
| Error Handling for API & Edge Cases         | ✅           |
| Filtering/Sorting + Detail Pages            | ✅           |
| README with Setup Instructions              | ✅           |

---

## 🏗️ Possible Improvements

- [ ] Add user login/registration
- [ ] Add favorite/bookmarked restaurants
- [ ] Implement Google Maps integration
- [ ] Add custom animation transitions
- [ ] Dark mode toggle

---

## 📫 Contact

**Author:** Iftikhar Sikder  
**GitHub:** [@IftikharSikder](https://github.com/IftikharSikder)

---

