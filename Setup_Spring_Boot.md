# Setup Spring Boot dan Konfigurasi PostgreSQL/MySQL

## 1. Instalasi dan Setup Spring Boot

### a. Prasyarat:
- **Java JDK 11 atau lebih baru**
- **Maven atau Gradle**
- **Spring Boot (Spring Initializr atau manual setup)**

### b. Membuat Proyek Spring Boot dengan Spring Initializr
1. Buka [Spring Initializr](https://start.spring.io/).
2. Pilih:
   - **Project:** Maven / Gradle
   - **Language:** Java
   - **Spring Boot Version:** (versi terbaru)
   - **Dependencies:** Spring Web, Spring Data JPA, PostgreSQL / MySQL Driver
3. Klik **Generate** dan unduh proyeknya.
4. Ekstrak dan buka proyek di IDE seperti IntelliJ IDEA atau VS Code.

## 2. Konfigurasi PostgreSQL/MySQL

### a. Menyiapkan Database PostgreSQL/MySQL
1. **PostgreSQL**
   - Install PostgreSQL: `sudo apt install postgresql` (Linux) atau unduh dari [postgresql.org](https://www.postgresql.org/download/).
   - Buat database: `CREATE DATABASE springboot_db;`
   - Buat user: `CREATE USER springuser WITH PASSWORD 'password123';`
   - Berikan hak akses: `GRANT ALL PRIVILEGES ON DATABASE springboot_db TO springuser;`

2. **MySQL**
   - Install MySQL: `sudo apt install mysql-server` atau unduh dari [mysql.com](https://dev.mysql.com/downloads/).
   - Masuk ke MySQL: `mysql -u root -p`
   - Buat database: `CREATE DATABASE springboot_db;`
   - Buat user: `CREATE USER 'springuser'@'localhost' IDENTIFIED BY 'password123';`
   - Berikan hak akses: `GRANT ALL PRIVILEGES ON springboot_db.* TO 'springuser'@'localhost';`

### b. Konfigurasi `application.properties`

Untuk PostgreSQL:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/springboot_db
spring.datasource.username=springuser
spring.datasource.password=password123
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```

Untuk MySQL:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/springboot_db?useSSL=false&serverTimezone=UTC
spring.datasource.username=springuser
spring.datasource.password=password123
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
```

### c. Menjalankan Aplikasi Spring Boot
1. Jalankan perintah berikut di terminal:
   ```bash
   mvn spring-boot:run
   ```
2. Aplikasi akan berjalan pada `http://localhost:8080`

## Kesimpulan
- Spring Boot mempermudah pengembangan aplikasi Java dengan konfigurasi minimal.
- Arsitektur Microservice memungkinkan skalabilitas dan modularitas lebih baik dibanding monolitik.
- PostgreSQL dan MySQL dapat dengan mudah dikonfigurasi dalam proyek Spring Boot.
- Dengan konfigurasi yang tepat, aplikasi dapat berjalan dengan optimal di berbagai lingkungan produksi.
