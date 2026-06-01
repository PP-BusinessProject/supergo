# SuperGo

## ![Icon](./source/assets/logo.png?raw=true 'Logo')

Платформа для анализа цен супермаркетов и поиска выгодных предложений. Она автоматически собирает, нормализует и сопоставляет товары между разными магазинами, формируя единую структурированную базу цен.

Платформа позволяет пользователям находить наиболее выгодные предложения, отслеживать изменения цен и анализировать динамику скидок в режиме реального времени. Благодаря интеллектуальному сопоставлению товаров система определяет аналоги между разными магазинами и формирует объективное сравнение стоимости.

Решение помогает пользователям сравнивать цены в разных магазинах, находить более выгодные предложения и экономить деньги за счёт анализа больших объёмов данных.

## Commands

### Build Android

flutter build apk --release --split-per-abi --split-debug-info --obfuscate

### Update Dependencies

flutter pub outdated  --prereleases --dependency-overrides --dev-dependencies

### Create Launch Icons

flutter pub run flutter_launcher_icons:main

### Native Splash

flutter pub run flutter_native_splash:create

flutter pub run flutter_native_splash:remove

### Android: Create Signing Key

keytool -genkey -v -keystore android/app/key.keystore -alias dreamdash -keyalg RSA -keysize 2048 -validity 10000
keytool -importkeystore -srckeystore android/app/key.keystore -destkeystore android/app/key.keystore -deststoretype pkcs12
