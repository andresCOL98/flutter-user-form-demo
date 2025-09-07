# 🏗️ Arquitectura del Proyecto Flutter

## Descripción General

Este proyecto implementa **Clean Architecture** con el patrón **MVVM** utilizando **BLoC** como manejador de estado. La arquitectura está diseñada para ser escalable, mantenible y testeable.

## 📋 Principios de Arquitectura

- **Separación de responsabilidades**: Cada capa tiene una responsabilidad específica
- **Inversión de dependencias**: Las capas internas no dependen de las externas
- **Inyección de dependencias**: Gestión centralizada de dependencias
- **Testabilidad**: Cada componente puede ser testeado independientemente
- **Reutilización**: Código compartido en el core del proyecto

## 📁 Estructura de Carpetas

```
lib/
├── core/                           # Funcionalidades compartidas
│   ├── constants/                  # Constantes globales
│   ├── errors/                     # Manejo de errores y excepciones
│   ├── network/                    # Configuración de red
│   ├── params/                     # Parámetros para casos de uso
│   ├── resources/                  # Recursos compartidos (DataState, etc.)
│   ├── usecases/                   # Caso de uso base
│   └── utils/                      # Utilidades y helpers
├── features/                       # Funcionalidades específicas
│   └── user_form/                  # Feature de formulario de usuario
│       ├── data/                   # Capa de datos
│       │   ├── datasources/        # Fuentes de datos
│       │   ├── models/             # Modelos de datos
│       │   └── repositories/       # Implementación de repositorios
│       ├── domain/                 # Capa de dominio (reglas de negocio)
│       │   ├── entities/           # Entidades de negocio
│       │   ├── repositories/       # Interfaces de repositorios
│       │   └── usecases/           # Casos de uso específicos
│       └── presentation/           # Capa de presentación
│           ├── bloc/               # BLoCs (ViewModels)
│           ├── pages/              # Páginas/Pantallas
│           └── widgets/            # Widgets reutilizables
├── injection_container/            # Inyección de dependencias
└── main.dart                       # Punto de entrada de la aplicación
```

## 🔧 Core (Funcionalidades Compartidas)

### `core/constants/`
- **Propósito**: Almacena todas las constantes globales de la aplicación
- **Contenido típico**: 
  - URLs de API
  - Textos estáticos
  - Configuraciones globales
  - Keys para SharedPreferences

### `core/errors/`
- **Propósito**: Manejo centralizado de errores y excepciones
- **Contenido típico**:
  - Excepciones personalizadas
  - Clases Failure
  - Mapeo de errores

### `core/network/`
- **Propósito**: Configuración y utilidades de red
- **Contenido típico**:
  - Cliente HTTP (Dio, http)
  - Interceptores
  - Configuración de timeout
  - Manejo de conectividad

### `core/params/`
- **Propósito**: Parámetros para casos de uso
- **Contenido típico**:
  - Clases de parámetros para UseCases
  - DTOs para transferencia de datos

### `core/resources/`
- **Propósito**: Recursos y utilidades compartidas
- **Contenido típico**:
  - DataState (Success, Error, Loading)
  - Resource wrappers
  - Estados comunes

### `core/usecases/`
- **Propósito**: Caso de uso base y interfaces
- **Contenido típico**:
  - UseCase abstract class
  - Interfaces base

### `core/utils/`
- **Propósito**: Utilidades y funciones helper
- **Contenido típico**:
  - Extensiones de Dart/Flutter
  - Validadores
  - Formatters
  - Helpers generales

## 🎯 Features (Funcionalidades)

Cada feature sigue el patrón de **Clean Architecture** con 3 capas principales:

### 📊 Data Layer (`features/*/data/`)

#### `datasources/`
- **Propósito**: Fuentes de datos concretas
- **Contenido**:
  - `remote/` - APIs, servicios web
  - `local/` - Base de datos local, SharedPreferences
- **Responsabilidades**:
  - Obtener datos de fuentes externas
  - Cacheo de datos
  - Manejo de conectividad

#### `models/`
- **Propósito**: Modelos de datos con serialización
- **Contenido**:
  - Clases con `fromJson()` y `toJson()`
  - Extensión de entidades del dominio
- **Responsabilidades**:
  - Serialización/Deserialización JSON
  - Mapeo entre API y entidades

#### `repositories/`
- **Propósito**: Implementación concreta de repositorios
- **Contenido**:
  - Implementación de interfaces del dominio
  - Lógica de decisión entre fuentes de datos
- **Responsabilidades**:
  - Orquestar datasources
  - Manejo de errores
  - Cacheo inteligente

### 🏛️ Domain Layer (`features/*/domain/`)

#### `entities/`
- **Propósito**: Entidades de negocio puras
- **Contenido**:
  - Clases con lógica de negocio
  - Sin dependencias externas
- **Responsabilidades**:
  - Representar objetos de negocio
  - Contener reglas de validación

#### `repositories/`
- **Propósito**: Contratos/Interfaces de repositorios
- **Contenido**:
  - Abstract classes o interfaces
- **Responsabilidades**:
  - Definir contratos para acceso a datos
  - Independencia de implementación

#### `usecases/`
- **Propósito**: Casos de uso específicos del feature
- **Contenido**:
  - Clases que implementan UseCase base
  - Lógica de negocio específica
- **Responsabilidades**:
  - Orquestar reglas de negocio
  - Interactuar con repositorios

### 🎨 Presentation Layer (`features/*/presentation/`)

#### `bloc/`
- **Propósito**: BLoCs que actúan como ViewModels en MVVM
- **Contenido**:
  - BLoC classes
  - Event classes
  - State classes
- **Responsabilidades**:
  - Manejo de estado de UI
  - Procesamiento de eventos de usuario
  - Comunicación con casos de uso

#### `pages/`
- **Propósito**: Pantallas/Páginas de la aplicación
- **Contenido**:
  - Widgets de pantalla completa
  - Configuración de rutas
- **Responsabilidades**:
  - Estructura visual de pantallas
  - Navegación
  - Inyección de BLoCs

#### `widgets/`
- **Propósito**: Widgets reutilizables del feature
- **Contenido**:
  - Custom widgets
  - Componentes UI específicos
- **Responsabilidades**:
  - Componentes UI reutilizables
  - Lógica de presentación específica

## 🔌 Injection Container

### `injection_container/`
- **Propósito**: Configuración de inyección de dependencias
- **Contenido**:
  - Setup de GetIt, Injectable, o similar
  - Registro de dependencias
- **Responsabilidades**:
  - Registro de singletons
  - Configuración de factories
  - Resolución de dependencias

## 🔄 Flujo de Datos

```
UI (Widget) → BLoC (ViewModel) → UseCase → Repository → DataSource
     ↑                                                        ↓
     ←---------←---------←---------←---------←---------←------
```

### Flujo de una acción típica:

1. **User Input**: Usuario interactúa con UI
2. **Event**: Widget dispara evento al BLoC
3. **BLoC**: Procesa evento y llama UseCase
4. **UseCase**: Ejecuta lógica de negocio
5. **Repository**: Obtiene datos del DataSource apropiado
6. **DataSource**: Fetch data (API/Local)
7. **Response**: Datos fluyen de vuelta
8. **State**: BLoC emite nuevo estado
9. **UI Update**: Widget se reconstruye con nuevo estado

## 🧪 Estrategia de Testing

### Unit Tests
- **Core**: Utilities, constants, error handling
- **Domain**: Entities, use cases
- **Data**: Models, repositories
- **Presentation**: BLoC logic

### Integration Tests
- **Features completos**: Flujo end-to-end
- **API integration**: DataSources con APIs reales

### Widget Tests
- **Pages**: Rendering y interacciones
- **Widgets**: Comportamiento de componentes

## 📦 Dependencias Principales

- **flutter_bloc**: Manejo de estado
- **get_it**: Inyección de dependencias
- **dio**: Cliente HTTP
- **equatable**: Comparación de objetos
- **dartz**: Programación funcional (Either)

## 🔍 Convenciones de Naming

- **Archivos**: `snake_case.dart`
- **Clases**: `PascalCase`
- **Variables**: `camelCase`
- **Constantes**: `UPPER_SNAKE_CASE`
- **BLoCs**: `FeatureBloc`, `FeatureEvent`, `FeatureState`
- **UseCases**: `VerbNounUseCase` (ej: `CreateUserUseCase`)

## 📝 Ejemplo de Implementación

### Entity (Domain)
```dart
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  
  const User({required this.id, required this.name, required this.email});
  
  @override
  List<Object> get props => [id, name, email];
}
```

### UseCase (Domain)
```dart
class CreateUserUseCase implements UseCase<User, CreateUserParams> {
  final UserRepository repository;
  
  CreateUserUseCase(this.repository);
  
  @override
  Future<Either<Failure, User>> call(CreateUserParams params) {
    return repository.createUser(params);
  }
}
```

### BLoC (Presentation)
```dart
class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  final CreateUserUseCase createUserUseCase;
  
  UserFormBloc({required this.createUserUseCase}) : super(UserFormInitial()) {
    on<CreateUserEvent>(_onCreateUser);
  }
  
  void _onCreateUser(CreateUserEvent event, Emitter<UserFormState> emit) async {
    emit(UserFormLoading());
    
    final result = await createUserUseCase(CreateUserParams(
      name: event.name,
      email: event.email,
    ));
    
    result.fold(
      (failure) => emit(UserFormError(failure.message)),
      (user) => emit(UserFormSuccess(user)),
    );
  }
}
```

## 🚀 Beneficios de esta Arquitectura

1. **Escalabilidad**: Fácil agregar nuevas features
2. **Mantenibilidad**: Código organizado y limpio
3. **Testabilidad**: Cada capa puede testearse independientemente
4. **Reutilización**: Core compartido entre features
5. **Flexibilidad**: Fácil cambiar implementaciones
6. **Team Collaboration**: Estructura clara para equipos grandes

## 📖 Referencias

- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter BLoC Library](https://bloclibrary.dev/)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)

---

**Creado por**: [Tu nombre]  
**Fecha**: 6 de Septiembre, 2025  
**Versión**: 1.0.0
