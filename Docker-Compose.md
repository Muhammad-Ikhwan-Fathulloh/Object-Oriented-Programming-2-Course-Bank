# 🚀 Spring Boot + Docker Compose + MySQL

Contoh proyek sederhana **Spring Boot + Thymeleaf** yang berjalan di dalam container **Docker Compose**, lengkap dengan **seed data otomatis**.

---

## 📁 Struktur Folder

```
springboot-docker-compose/
├── mysql-init/                        # (jika pakai init.sql)
│   └── init.sql
├── src/
│   └── main/
│       ├── java/com/example/demo/
│       │   ├── DemoApplication.java
│       │   ├── controller/HomeController.java
│       │   ├── model/User.java
│       │   ├── repository/UserRepository.java
│       │   └── DataSeeder.java        # (CommandLineRunner)
│       └── resources/
│           ├── application.properties
│           ├── templates/index.html
│           └── db/migration/V1__init_users.sql  # (Flyway)
├── .dockerignore
├── Dockerfile
├── docker-compose.yml
└── pom.xml
```

---

## 🔧 1. `pom.xml`

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" ...>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>demo</artifactId>
  <version>0.0.1-SNAPSHOT</version>

  <dependencies>
    <!-- Web & Thymeleaf -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>

    <!-- JPA + MySQL -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-j</artifactId>
    </dependency>

    <!-- Flyway Migration -->
    <dependency>
      <groupId>org.flywaydb</groupId>
      <artifactId>flyway-core</artifactId>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
    </plugins>
  </build>
</project>
```

---

## ⚙️ 2. `application.properties`

```properties
spring.datasource.url=jdbc:mysql://mysql-db:3306/demo_db
spring.datasource.username=root
spring.datasource.password=root
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.thymeleaf.cache=false
spring.flyway.enabled=true
```

---

## 🧩 3. `User.java`

```java
package com.example.demo.model;

import jakarta.persistence.*;

@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    public User() {}
    public User(Long id, String name) { this.name = name; }

    // Getter & Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}
```

---

## 🧠 4. `UserRepository.java`

```java
package com.example.demo.repository;

import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {}
```

---

## 🎮 5. `HomeController.java`

```java
package com.example.demo.controller;

import com.example.demo.repository.UserRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    private final UserRepository userRepository;

    public HomeController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("users", userRepository.findAll());
        return "index";
    }
}
```

---

## 🌐 6. `index.html`

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
  <meta charset="UTF-8">
  <title>Spring Boot + Docker</title>
</head>
<body>
  <h1>Daftar User</h1>
  <ul>
    <li th:each="user : ${users}" th:text="${user.name}"></li>
  </ul>
</body>
</html>
```

---

## ✅ 7A. `DataSeeder.java` *(CommandLineRunner Option)*

```java
package com.example.demo;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataSeeder {
    @Bean
    CommandLineRunner initDatabase(UserRepository userRepository) {
        return args -> {
            if (userRepository.count() == 0) {
                userRepository.save(new User(null, "Alice"));
                userRepository.save(new User(null, "Bob"));
                userRepository.save(new User(null, "Charlie"));
                System.out.println(">>> Seed sukses dari CommandLineRunner");
            }
        };
    }
}
```

---

## ✅ 7B. `V1__init_users.sql` *(Flyway Option)*

```sql
CREATE TABLE IF NOT EXISTS user (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO user (name) VALUES ('Alice'), ('Bob'), ('Charlie');
```

Path: `src/main/resources/db/migration/V1__init_users.sql`

---

## 🐋 8. `Dockerfile`

```Dockerfile
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 📦 9. `.dockerignore`

```dockerignore
target/
.git
.idea
*.log
```

---

## 🧬 10. `docker-compose.yml`

```yaml
version: '3.8'

services:
  mysql-db:
    image: mysql:8
    container_name: mysql-db
    environment:
      MYSQL_DATABASE: demo_db
      MYSQL_ROOT_PASSWORD: root
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      # - ./mysql-init:/docker-entrypoint-initdb.d  # ← Jika pakai init.sql manual

  springboot-app:
    build: .
    container_name: springboot-app
    depends_on:
      - mysql-db
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql-db:3306/demo_db
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root

volumes:
  mysql-data:
```

---

## 🚀 11. Build & Jalankan

```bash
./mvnw clean package
docker-compose down -v      # hapus volume agar Flyway/init.sql jalan ulang
docker-compose up --build
```

---

## 🌐 12. Akses Web

```text
http://localhost:8080
```

> Harus muncul: **Daftar User** dari hasil seed (`Alice`, `Bob`, `Charlie`)

---

## 💡 Tips Tambahan

| Metode Seed       | File                  | Kelebihan                          |
| ----------------- | --------------------- | ---------------------------------- |
| CommandLineRunner | `DataSeeder.java`     | Sederhana, cepat                   |
| Flyway SQL        | `V1__init_users.sql`  | Ideal untuk versi/migrasi nyata    |
| Init SQL Docker   | `mysql-init/init.sql` | Hanya untuk seed pertama kali saja |
