# Account Service — Balance API

Микросервис для управления балансами банковских счетов.

На текущем этапе сервис предоставляет API для:

* создания баланса;
* получения баланса;
* изменения баланса;
* авторизации изменения баланса;
* подтверждения авторизации;
* освобождения авторизации.

## Tech Stack

* Java 17
* Spring Boot 3.0.6
* Spring Web
* Spring Data JPA
* Spring Data JDBC
* PostgreSQL
* Liquibase
* OpenFeign
* Bean Validation
* MapStruct
* Lombok
* Swagger / OpenAPI
* Gradle

## Application

Сервис запускается на:

```text
http://localhost:8090
```

Context path:

```text
/api
```

Поэтому все REST endpoints начинаются с:

```text
http://localhost:8090/api
```

## Database Configuration

Настройки PostgreSQL задаются через переменные окружения:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:postgres}
    username: ${DB_USERNAME:user}
    password: ${DB_PASSWORD:password}
```

### Переменные окружения

| Variable      | Default     | Description       |
| ------------- | ----------- | ----------------- |
| `DB_HOST`     | `localhost` | PostgreSQL host   |
| `DB_PORT`     | `5432`      | PostgreSQL port   |
| `DB_NAME`     | `postgres`  | Database name     |
| `DB_USERNAME` | `user`      | Database username |
| `DB_PASSWORD` | `password`  | Database password |
| `DB_SCHEMA`   | `public`    | PostgreSQL schema |

Hibernate schema generation отключена:

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: none
```

Изменения структуры базы данных выполняются через Liquibase.

## Liquibase

Главный changelog:

```text
src/main/resources/db/changelog/db.changelog-master.yaml
```

Liquibase использует schema, заданную через:

```text
DB_SCHEMA
```

По умолчанию используется:

```text
public
```

## Balance API

Base URL:

```text
/api/v1/balances
```

### Create Balance

Создание новой записи баланса.

### Get Balance

Получение баланса по ID.

### Update Balance

Изменение баланса по ID.

### Authorize Balance Change

Авторизация изменения баланса.

### Confirm Authorization

Подтверждение авторизации изменения баланса.

### Release Authorization

Освобождение авторизации изменения баланса.

## API Summary

| Method  | Endpoint                                 | Description              |
| ------- | ---------------------------------------- | ------------------------ |
| `POST`  | `/api/v1/balances`                       | Create balance           |
| `GET`   | `/api/v1/balances/{balanceId}`           | Get balance              |
| `PUT`   | `/api/v1/balances/{balanceId}`           | Update balance           |
| `PATCH` | `/api/v1/balances/{balanceId}/authorize` | Authorize balance change |
| `PATCH` | `/api/v1/balances/{balanceId}/confirm`   | Confirm authorization    |
| `PATCH` | `/api/v1/balances/{balanceId}/release`   | Release authorization    |

## User Identification

Для обычных запросов сервис использует HTTP header:

```http
x-user-id: <userId>
```

Пример:

```http
GET /api/v1/balances/1
x-user-id: 1
```

Без этого заголовка запрос может быть отклонён `UserHeaderFilter`.

Swagger/OpenAPI endpoints освобождены от проверки `x-user-id`.

## Swagger / OpenAPI

После запуска сервиса Swagger UI доступен по адресу:

```text
http://localhost:8090/api/swagger-ui/index.html
```

OpenAPI specification:

```text
http://localhost:8090/api/v3/api-docs
```

Swagger позволяет просматривать и тестировать Balance API.

## Running Locally

Сборка проекта:

```powershell
./gradlew clean build
```

Запуск приложения:

```powershell
./gradlew bootRun
```

После запуска API будет доступен по адресу:

```text
http://localhost:8090/api
```

## Running with Docker

Сборка JAR:

```powershell
./gradlew clean build
```

Сборка Docker image:

```powershell
docker build -t account-service .
```

Запуск:

```powershell
docker run --name account-service -p 8090:8090 account-service
```

После запуска:

```text
http://localhost:8090/api
```

## Running with Docker Compose

Если сервис запускается вместе с инфраструктурой через Docker Compose:

```powershell
cd ../infra
docker compose -f docker-compose.yaml -f docker-compose.services.yaml up -d
```

Проверить состояние контейнеров:

```powershell
cd ../infra
docker compose -f docker-compose.yaml -f docker-compose.services.yaml ps
```

Посмотреть логи account-service:

```powershell
docker compose -f docker-compose.yaml -f docker-compose.services.yaml logs -f account-service
```

## Project Structure

Основные части Balance API:

```text
src/main/java/faang/school/accountservice/
├── controller/
│   └── balance/
│       └── BalanceController.java
├── service/
│   └── balance/
│       └── BalanceService.java
├── dto/
│   └── balance/
│       ├── BalanceDto.java
│       ├── CreateBalanceDto.java
│       ├── UpdateBalanceDto.java
│       └── ChangedBalanceDto.java
├── entity/
├── repository/
└── config/
```

## Validation

DTOs, используемые Balance API, проходят Jakarta Bean Validation через аннотацию `@Valid`.

Некорректные данные запроса могут привести к:

```text
400 Bad Request
```
