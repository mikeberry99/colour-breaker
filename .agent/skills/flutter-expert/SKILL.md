---
name: flutter-expert
description: Use this skill when generating, refactoring, or reviewing Flutter code translated from Google Stitch designs. This ensures the output matches rigid production-grade software engineering principles.
---

# Flutter Clean Architecture Expert

## Purpose
Use this skill when generating, refactoring, or reviewing Flutter code translated from Google Stitch designs. This ensures the output matches rigid production-grade software engineering principles.

## Instructions & Architecture
* **State Management:** Always use **Riverpod** (`flutter_riverpod`) for managing state. Do not use raw stateful widgets for business logic.
* **Folder Structure:** Enforce a strict **Clean Architecture** layout:
  * `lib/features/[feature_name]/presentation/` (Widgets and UI State Providers)
  * `lib/features/[feature_name]/domain/` (Entities and Use Cases)
  * `lib/features/[feature_name]/data/` (Models and Repositories)
* **Design Token Mapping:** Directly translate Stitch metadata hex colors and spacing values into a centralized abstract `ThemeData` file rather than hardcoding values inline.

## Constraints
* Do not mix business logic with UI layout code.
* Do not use standard navigation; prefer `go_router` for deep linking and declarative routing.
* Never generate native platform code (Kotlin/Swift) without explicitly asking the user first.