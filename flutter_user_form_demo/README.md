# Flutter User Form Demo

Una aplicación Flutter que implementa un formulario de usuarios con arquitectura Clean Architecture y patrón BLoC (mvvm).

## 📋 Requisitos del Sistema

### Versiones Específicas Requeridas

- **Flutter**: `3.27.2` (canal estable)
- **Dart**: `3.6.1`
- **Java JDK**: `17` (OpenJDK o Oracle JDK)
- **Android SDK**: API level 34 mínimo
- **Gradle**: `8.0+` (incluido con Flutter)

### Herramientas Adicionales

- **Android Studio** o **VS Code** con extensiones de Flutter
- **Git** para clonar el repositorio

## 🚀 Instalación y Configuración

### 1. Verificar Instalación de Flutter
```bash
flutter doctor
```
> Asegúrate de que todas las verificaciones pasen correctamente.

### 2. Clonar el Repositorio
```bash
git clone <repository-url>
cd flutter_user_form_demo
```

### 3. Instalar Dependencias
```bash
flutter pub get
```

### 4. Configurar Dispositivo

#### Para Android:
```bash
# Verificar dispositivos conectados
flutter devices

# Si usas emulador, iniciarlo desde Android Studio o:
flutter emulators
flutter emulators --launch <emulator-id>
```

#### Para iOS (solo macOS):
```bash
# Instalar pods (si es necesario)
cd ios && pod install && cd ..
```

## ▶️ Ejecutar la Aplicación

### Modo Debug
```bash
flutter run
```

### Modo Release
```bash
flutter run --release
```

### Para dispositivo específico
```bash
flutter run -d <device-id>
```

## 🧪 Ejecutar Tests

### Todos los tests
```bash
flutter test
```

### Tests específicos
```bash
# Tests de dominio
flutter test test/features/user_form/domain/

# Test específico
flutter test test/features/user_form/domain/entities/user_test.dart
```

## 🏗️ Arquitectura

- **Clean Architecture** con capas: Domain, Data, Presentation
- **BLoC Pattern** para manejo de estado
- **Dependency Injection** con GetIt
- **Repository Pattern** para abstracción de datos

## 📱 Funcionalidades

- ✅ Lista de usuarios con estado vacío
- ✅ Formulario de creación/edición de usuarios
- ✅ Gestión de direcciones por usuario
- ✅ Selección de ubicación (País, Departamento, Municipio)
- ✅ Validaciones de formulario
- ✅ Persistencia local con SQLite

## 🛠️ Troubleshooting

### Error de Java Version
```bash
# Verificar versión de Java
java -version

# Si no tienes Java 17, instalar OpenJDK 17
```

### Error de Gradle
```bash
# Limpiar proyecto
flutter clean
flutter pub get
```

### Error de Permisos Android
```bash
# En Android Studio: Tools → SDK Manager → SDK Tools
# Verificar que Android SDK Build-Tools esté instalado
```

## 📞 Soporte

Si encuentras problemas:
1. Verifica que cumples todos los requisitos de versiones
2. Ejecuta `flutter doctor` para diagnosticar problemas
3. Limpia el proyecto con `flutter clean && flutter pub get`
