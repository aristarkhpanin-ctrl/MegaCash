/// Пути экранов. Коды в комментариях — из макетов.
abstract final class Routes {
  // Группа А — ежедневное использование.
  static const home = '/home'; // А1 · Главный
  static const answer = '/home/answer'; // А2 · Какой картой платить
  static const cards = '/cards'; // А3 · Мои карты
  static const cardEdit = '/cards/edit'; // А4 · Карточка банка

  // Группа Б — месячная настройка. Рекламы нет ни на одном экране.
  static const setup = '/setup'; // Б1 · Начало настройки
  static const setupScreenshots = '/setup/screenshots'; // Б2 · Загрузка
  static const setupRecognizing = '/setup/recognizing'; // Б3 · Распознавание
  static const setupReview = '/setup/review'; // Б4 · Проверка
  static const setupManual = '/setup/manual'; // Б5 · Ручной ввод
  static const setupRecommendation = '/setup/recommendation'; // Б6 · Рекомендация
  static const setupActivation = '/setup/activation'; // Б7 · Инструкция
  static const setupDone = '/setup/done'; // Б8 · Подтверждение

  // Группа В — онбординг.
  static const onboarding = '/onboarding'; // В1 · Что делает приложение
  static const onboardingPermission = '/onboarding/permission'; // В2 · Галерея
  static const onboardingFirstCard = '/onboarding/first-card'; // В3 · Первая карта

  // Группа Г — служебное.
  static const settings = '/settings'; // Г1 · Настройки
  static const about = '/settings/about'; // Г2 · О приложении
}
