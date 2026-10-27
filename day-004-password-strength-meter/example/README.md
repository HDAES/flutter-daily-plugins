# Password Strength Meter demo

Local-only Flutter example. It makes no network requests and does not store passwords.

From the Day 004 directory:

~~~bash
cd example
flutter create . --platforms=android,ios,web
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
~~~

Use flutter devices to select another target. The flutter create command adds platform runner files that are intentionally not checked in.
