# Flutter Blog App

Alhamdulillah, this is a fully functional **Blog App** built using **Flutter** and **Firebase**. The app allows users to create profiles, post content, interact with others, and receive notifications.

---

## Features

### Profile View
- Create and update user profile.
- View total posts, total reactions, and total followers.
- View list of followers.
- View list of users who have sent messages.
- Interact with other users by sending messages.

### Home View
- Create and view posts.
- View other users' posts.
- Comment and react (love) on posts.
- Visit other users' profiles.
- Follow and send messages to other users from their profile.
- global chat system (many-to-many)
- one-to-one chat system
- Notifications bar to see:
  - Users who reacted or commented on your posts.
  - Users who have followed.

---
## 📸 App UI Preview

<p align="center">
  <img src="lib/assets/appUi/login.png" alt="UI Screen 1" width="200"/>
  <img src="lib/assets/appUi/register.png" alt="UI Screen 2" width="200"/>
  <img src="lib/assets/appUi/profile.png" alt="UI Screen 3" width="200"/>
</p>

<p align="center">
  <img src="lib/assets/appUi/allFollowers.png" alt="UI Screen 4" width="200"/>
  <img src="lib/assets/appUi/AllMessages.png" alt="UI Screen 5" width="200"/>
  <img src="lib/assets/appUi/home.png" alt="UI Screen 6" width="200"/>
  <img src="lib/assets/appUi/comment.png" alt="UI Screen 6" width="200"/>
</p>

<p align="center">
  <img src="lib/assets/appUi/home_user_profile.png" alt="UI Screen 7" width="200"/>
  <img src="lib/assets/appUi/one_to_one_chat.png" alt="UI Screen 7" width="200"/>
  <img src="lib/assets/appUi/global_chatroom.png" alt="UI Screen 7" width="200"/>
  <img src="lib/assets/appUi/react_notif.png" alt="UI Screen 6" width="200"/>
  <img src="lib/assets/appUi/following_notif.png" alt="UI Screen 6" width="200"/>
</p>

---
## Packages Used

```yaml
firebase_core: ^4.0.0
firebase_auth: ^6.0.0
firebase_analytics: ^12.0.0
cloud_firestore: ^6.0.0
provider: ^6.1.5
cloudinary_flutter: ^1.0.0
cloudinary_url_gen: ^1.0.0
image_picker: ^1.1.2
path: ^1.8.3
mime: ^1.0.4
http_parser: ^4.0.2
dotted_border: ^3.1.0
fluentui_system_icons: ^1.1.273
get_storage: ^2.1.1
intl: ^0.20.2
http: ^1.5.0
loading_animation_widget: ^1.3.0
flutter_hooks: ^0.21.3
