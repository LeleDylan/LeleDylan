# PuntajePro (Saber 11 ICFES)

Aplicación Flutter (canal stable, null-safety) para plan diario, simulacros, analíticas y modo offline.

## Requisitos previos
- Flutter stable y Dart instalados.
- Cuenta de Firebase con proyecto configurado.
- Acceso a Google Play Console para crear el producto in-app `pro_monthly`.

## Configuración
1. Instala dependencias:
   ```bash
   flutter pub get
   ```
2. Configura Firebase:
   - Crea un proyecto en Firebase y habilita **Auth (email/password y Google)**, **Firestore**, **Analytics** y **Crashlytics**.
   - Descarga `google-services.json` y colócalo en `android/app/`.
   - En iOS/macOS agrega el `GoogleService-Info.plist` en los targets correspondientes.
   - Agrega la clase `DefaultFirebaseOptions` si usas `flutterfire configure` o inicializa manualmente como en `AppStartNotifier.initialize`.
3. Auth:
   - En Google Sign-In configura el SHA-1 y SHA-256 de tu app en Firebase Console.
4. Firestore:
   - Crea colecciones `questions` (campos: `area`, `topic`, `statement`, `options` [array], `answerIndex`, `explanation`).
   - Opcional: colección `packs/{packId}/questions` para packs descargables.
   - Crea `progress/current` para persistir progreso (o deja que la app lo genere tras un simulacro).
5. Crashlytics/Analytics:
   - Sigue el asistente de Firebase para subir los símbolos nativos en Android/iOS si aplican.
6. In-App Purchases (Android):
   - En Play Console, en Productos integrados, crea un **producto no consumible** `pro_monthly` con precio mensual.
   - Usa la firma de licencia y testers internos para probar compras.
   - Acepta las políticas de facturación y configura métodos de pago.

## Ejecución
```bash
flutter run
```

## Estructura (Clean-ish + Riverpod)
- `lib/domain` modelos (`Question`, `Attempt`, `UserProgress`, `DownloadPack`), repositorios e interactor (`ScoreCalculator`).
- `lib/data` implementaciones locales (Hive + seed JSON) y remotas (Firestore, Auth, IAP).
- `lib/presentation` UI con Riverpod: onboarding, home, simulacro, resultados, descargas offline, paywall pro.
- `assets/seed/questions.json` con 30 preguntas dummy para usar sin Firestore.

## Offline
- Hive almacena preguntas descargadas y progreso.
- Pantalla **Descargas** permite almacenar packs por área.
- El simulacro rápido cae a caché/seed si no hay red.

## Pruebas
- Se incluyen 5 pruebas unitarias de modelos, cálculo de score y fallback de repositorio. Ejecuta:
  ```bash
  flutter test
  ```

## Notas de calidad
- Lints de `flutter_lints` activas.
- Estados de carga/error manejados en providers Riverpod y UI.
- Crashlytics captura errores globales y Analytics registra apertura de app.

## Roadmap
Consulta `TODO.md` para próximos pasos sugeridos.
