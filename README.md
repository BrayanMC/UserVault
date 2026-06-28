# UserVault

Aplicacion iOS de gestion de usuarios que permite listar, agregar, editar y eliminar usuarios con integracion a una API REST y persistencia local en Realm.

## Stack Tecnologico

| Componente | Tecnologia |
|---|---|
| Lenguaje | Swift 5.9 (concurrency mode minimal) |
| UI | SwiftUI |
| Arquitectura | MVVM + Coordinators |
| Persistencia | Realm 20.x (realm-swift via SPM) |
| Networking | Alamofire 5.x (via SPM) |
| Concurrencia | async/await |
| iOS minimo | 15.0 |
| Localizacion | Espanol e Ingles (Localizable.xcstrings) |
| Linter | SwiftLint (strict mode) |
| Generacion de proyecto | XcodeGen |

## Decisiones Tecnicas

### Arquitectura MVVM + Coordinators
- Cada feature tiene su propio Coordinator protocol (`UserListCoordinatorProtocol`, etc.).
- `AppCoordinator` es el coordinador raiz y conforma todos los coordinator protocols.
- Los ViewModels reciben el Coordinator via su protocolo especifico (DI + ISP), nunca el concreto.
- `ViewModelFactory` centraliza la creacion de ViewModels (SRP).
- Se usa `NavigationView` con `NavigationLink(isActive:)` para navegacion programatica (compatible iOS 15).
- Los coordinator protocols estan anotados con `@MainActor` para evitar data races.

### Flujo de datos
```
View -> ViewModel -> UseCase -> Repository (protocol segregado) -> DataSource
```
Las Views nunca acceden a UseCases ni Repositories directamente.

### Estructura de carpetas
```
UserVault/
├── App/                        -> UserVaultApp, AppCoordinator, MainView, ViewModelFactory
├── Core/
│   ├── DesignSystem/           -> Colors, Typography, Spacing, DetailRow
│   ├── Extensions/             -> Date+Extensions, String+Extensions
│   └── Utils/                  -> AppDependencies, Constants, LocationManager, PreviewHelpers,
│                                  UserVaultError, Validators
├── Domain/
│   ├── Entities/               -> User, User+Extensions
│   ├── Repositories/           -> UserRepositoryProtocol (protocolos segregados + agregado)
│   └── UseCases/               -> GetUsersUseCase, CreateUserUseCase, UpdateUserUseCase, DeleteUserUseCase
├── Data/
│   ├── Network/                -> APIClient, URLBuilder (compartidos entre entities)
│   └── User/
│       ├── Local/              -> RealmUserObject, UserLocalDataSource, UserRepositoryImpl
│       └── Remote/             -> UserRemoteDataSource, UserDTO
├── Features/
│   ├── UserList/               -> UserListView, UserListViewModel, UserListCoordinator,
│   │                              UserRowView, UserListViewConstants
│   ├── UserDetail/             -> UserDetailView, UserDetailViewModel, UserDetailCoordinator,
│   │                              UserEditView, UserDetailViewConstants
│   └── UserCreate/             -> UserCreateView, UserCreateViewModel, UserCreateCoordinator,
│                                  UserCreateViewConstants
└── Resources/
    ├── Assets.xcassets/
    ├── Localizable.xcstrings
    └── Info.plist
```

### Estrategia de cache
- Primera vez: fetch desde API -> guardar todos los usuarios en Realm.
- Siguientes accesos: leer directo de Realm (filtrado `isDeleted == false`).
- Solo vuelve a la API si Realm no tiene registros con `isLocal == false`.
- Al guardar datos de la API, se filtran los IDs marcados como eliminados para no restaurarlos.

### Realm Best Practices
- Los `RealmObject` se mapean a structs del dominio (`User`) inmediatamente despues de leer.
- Nunca se pasan `RealmObject` entre threads.
- Los writes se realizan en el thread donde se abrio el Realm.
- Logs con `debugPrint` en cada operacion CRUD (`[Realm] FETCH`, `[Realm] SAVE`, etc.).

### Manejo de errores
- Enum `UserVaultError: LocalizedError` con casos para network, persistence, validation y locationDenied.
- Errores mostrados en UI via Alert.

### Localizacion
- Todas las strings de UI estan en `Localizable.xcstrings` con soporte para espanol e ingles.
- Extension `String.localized` para simplificar el uso (`"key".localized`).

### XcodeGen
Se utiliza [XcodeGen](https://github.com/yonaskolb/XcodeGen) para generar el archivo `.xcodeproj` a partir de un manifiesto declarativo (`project.yml`).

**Motivo:** El archivo `.xcodeproj` es un formato binario/XML complejo que genera conflictos de merge constantes cuando varios desarrolladores trabajan en paralelo. Con XcodeGen el `.xcodeproj` se ignora en git y cada desarrollador lo regenera localmente con `xcodegen generate`, eliminando esos conflictos. La fuente de verdad del proyecto pasa a ser `project.yml`.

**Configuracion actual en `project.yml`:**
- Target iOS 15.0, Swift 5.9, concurrency mode minimal.
- Dependencias SPM: Realm 20.x y Alamofire 5.x.
- Build Phase de SwiftLint como `preBuildScript`.
- Post-build script para embeber frameworks SPM en dispositivo fisico.
- Info.plist custom con permisos de ubicacion.

### SwiftLint
Se utiliza [SwiftLint](https://github.com/realm/SwiftLint) para aplicar reglas de estilo y calidad de codigo de forma automatica.

**Motivo:** Garantiza consistencia en el codigo entre todos los desarrolladores del equipo. Al estar en modo estricto con reglas `opt_in` habilitadas (force_unwrapping, trailing_closure, toggle_bool, etc.), previene patrones inseguros y fuerza buenas practicas de Swift.

**Integracion:**
- Configurado en `.swiftlint.yml` en la raiz del proyecto con reglas estrictas.
- Ejecutado automaticamente en cada build via `preBuildScript` en `project.yml`.
- Si SwiftLint no esta instalado, emite un warning en lugar de fallar el build.

## Principios SOLID Aplicados

| Principio | Aplicacion |
|---|---|
| **Single Responsibility** | `ViewModelFactory` solo crea ViewModels. `AppCoordinator` solo maneja navegacion. Cada UseCase encapsula una unica operacion de negocio. Cada archivo contiene un unico tipo principal. |
| **Open/Closed** | Nuevas features se agregan creando nuevos Coordinators, ViewModels y UseCases sin modificar los existentes. Data organizada por entity (`Data/User/`) para escalar. |
| **Liskov Substitution** | `UserRepositoryImpl` es sustituible por cualquier implementacion que conforme `UserRepositoryProtocol` (incluyendo `PreviewUserRepository` para previews). |
| **Interface Segregation** | Protocolos de repositorio segregados (`UserFetchRepository`, `UserCreateRepository`, `UserUpdateRepository`, `UserDeleteRepository`). Cada UseCase depende solo del protocolo que necesita. Cada ViewModel depende solo de su coordinator protocol especifico. |
| **Dependency Inversion** | Los ViewModels dependen de protocolos (`UserListCoordinatorProtocol`, `UserFetchRepository`), no de clases concretas. Las capas superiores nunca conocen implementaciones de las inferiores. |

## Patrones de Diseno

| Patron | Categoria | Ubicacion | Descripcion |
|---|---|---|---|
| **Coordinator** | Behavioral | `AppCoordinator`, `*CoordinatorProtocol` | Encapsula la logica de navegacion fuera de los ViewModels. Cada feature define su protocolo y `AppCoordinator` los conforma todos. |
| **Factory** | Creational | `ViewModelFactory` | Centraliza la creacion de ViewModels con sus dependencias inyectadas. Desacopla la construccion de objetos de su uso. |
| **Builder** | Creational | `URLBuilder` | Construye URLs de la API mediante una interfaz fluida (`urlBase().path(.getUsers).build()`). Permite agregar segmentos y parametros de forma encadenada. |
| **Repository** | Structural | `UserRepositoryProtocol`, `UserRepositoryImpl` | Abstrae el acceso a datos detras de protocolos segregados. Orquesta data sources locales y remotos. |
| **Use Case / Interactor** | Behavioral | `Domain/UseCases/` | Cada operacion de negocio es una clase aislada con un unico metodo `execute()`. Separa logica de negocio de presentacion y datos. |
| **Data Mapper** | Structural | `UserDTO.toDomain()`, `RealmUserObject.toDomain()/fromDomain()` | Transforma datos entre capas (API -> Domain, Domain -> Realm) evitando acoplamiento entre representaciones. |
| **Observer** | Behavioral | ViewModels (`@ObservableObject` + `@Published`) | SwiftUI observa cambios en el estado del ViewModel y actualiza la UI de forma reactiva. |
| **Facade** | Structural | `APIClient` | Simplifica la interfaz de Alamofire exponiendo un unico metodo generico `fetch(url:)` que oculta configuracion HTTP, serializacion y manejo de errores. |
| **Adapter** | Structural | `LocationManager` | Adapta la interfaz delegate-based de `CLLocationManager` a una interfaz reactiva con `@Published`, compatible con SwiftUI. |
| **Dependency Injection** | Creational | `AppDependencies` | Contenedor que construye y conecta todo el grafo de dependencias en un unico punto. Los objetos reciben sus dependencias via constructor. |
| **DAO (Data Access Object)** | Structural | `UserLocalDataSource`, `UserRemoteDataSource` | Encapsulan el acceso a almacenes de datos especificos (Realm y API REST), separando la mecanica de persistencia de la logica de negocio. |
| **Protocol-Oriented Design** | Architectural | Todo el proyecto | Uso extensivo de protocolos para abstracciones, habilitando bajo acoplamiento y testabilidad. |

## Instrucciones de Setup

### Prerrequisitos
- Xcode 16.0 o superior
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) instalado
- [SwiftLint](https://github.com/realm/SwiftLint) instalado

### Pasos

1. Clonar el repositorio:
```bash
git clone <repo-url>
cd UserVault
```

2. Generar el proyecto de Xcode:
```bash
xcodegen generate
```

3. Abrir el proyecto:
```bash
open UserVault.xcodeproj
```

4. Resolver dependencias SPM (Xcode las resuelve automaticamente al abrir).

5. Seleccionar un simulador con iOS 15.0+ y ejecutar (Cmd+R).

### SwiftLint
SwiftLint esta configurado con reglas estrictas en `.swiftlint.yml` y se ejecuta automaticamente como Build Phase (definido en `project.yml`). No requiere configuracion manual adicional.

## Aspectos Considerados

- **Compatibilidad iOS 15**: Se usa `NavigationView` (no `NavigationStack`), `PreviewProvider` (no `#Preview`), `@ObservableObject` + `@Published` (no `@Observable`).
- **Borrado logico**: Los usuarios eliminados se marcan con `isDeleted = true` en Realm, no se borran fisicamente. Al re-fetchear la API, los IDs eliminados se filtran.
- **Usuarios locales**: Los usuarios creados en la app se marcan con `isLocal = true`. Al crear, la lista se refresca automaticamente.
- **Edicion como sheet**: La edicion de usuario se presenta como `.sheet` separada (`UserEditView`), manteniendo SRP en `UserDetailView`.
- **Core Location**: Se solicita permiso `WhenInUse` y se captura la ubicacion una sola vez. Si no se puede obtener, se usan coordenadas por defecto (Lima, Peru).
- **Validaciones reutilizables**: El enum `Validators` centraliza validaciones de email y campos vacios.
- **Constants por feature**: Cada feature tiene su archivo `*ViewConstants` con magic numbers, imagenes SF Symbols y formatos.
- **Componentes reutilizables**: `DetailRow` esta en `Core/DesignSystem/` por ser generico, no especifico de una feature.
- **Logging**: `debugPrint` en `APIClient` y `UserLocalDataSource` para trazabilidad de operaciones de red y base de datos.
- **No se usa SwiftData**: Se mantiene Realm como unica solucion de persistencia.
