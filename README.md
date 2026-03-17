# 🍎 JingleEat — AI Video Recipes App

Приложение для кулинарного вдохновения: лента видео-рецептов + ИИ-ассистент (GigaChat).

## 🛠 Технологии
- **Stack:** Swift 6, UIKit (верстка кодом).
- **Concurrency:** Structured Concurrency (Async/Await).
- **Architecture:** MVVM + Services.
- **Data:** URLSession, FileManager (кэш видео), Keychain (Auth).

- **Экраны (5+):** Auth (UIKit), Feed (UIKit), Recipe, AI Chat, Profile.
- **Сеть:** Интеграция с Dropbox API и GigaChat API.
- **Кэширование:** Собственный `VideoLoader` для оффлайн-доступа к роликам.
- **Native:** 0 внешних зависимостей (только нативный SDK).
- **Безопасность:** Поддержка сертификатов Минцифры для работы с GigaChat.



## 🏗 Архитектурная схема
1. **View**: UIKit компоненты.
2. **ViewModel**: Логика состояний и обработка задач (Task).
3. **Services**: Сетевой слой, Кэш-менеджер, Сервис авторизации.

## 📁 Структура
- `/application` — Исходный код.
- `/presentation` — Материалы защиты.

## 👨‍💻 Автор
- **Даниил Загоруйко**
- **TG:** @your_telegram
- **Email:** dazagoruiko@edu.hse.ru
