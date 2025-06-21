# Spring Boot + Docker

Project ini adalah contoh sederhana cara **deploy aplikasi Spring Boot menggunakan Docker**, termasuk penggunaan template engine **Thymeleaf**.

---

## 🐳 Apa itu Docker?

**Docker** adalah platform yang memungkinkan kamu membungkus aplikasi beserta semua dependensinya ke dalam satu paket yang disebut *container*. Container ini dapat dijalankan di mana saja—selama ada Docker Engine—tanpa harus mengatur lingkungan (Java version, dependensi, dll) secara manual.

### 🧱 Keuntungan menggunakan Docker:

* Konsistensi antara development dan production
* Portabilitas tinggi
* Mudah di-deploy
* Isolasi lingkungan

---

## 🚀 Setup Project Spring Boot

### 1. Buat Project di [Spring Initializr](https://start.spring.io)

* **Project**: Maven
* **Language**: Java
* **Spring Boot**: Terbaru (misalnya 3.2.x)
* **Group**: `com.example`
* **Artifact**: `demo`
* **Name**: `demo`
* **Packaging**: Jar
* **Java**: 17 (atau sesuai versi di sistem)
* **Dependencies**:

  * Spring Web
  * Thymeleaf

Klik **"Generate"**, lalu ekstrak file ZIP tersebut dan buka di IDE seperti IntelliJ, VS Code, atau lainnya.

---

## ✍️ Tambahkan Endpoint dan View

### Controller

Buat file `HomeController.java`:

```java
package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("message", "Hello from Spring Boot with Thymeleaf and Docker!");
        return "index";
    }
}
```

### View (HTML Template)

Buat file `src/main/resources/templates/index.html`:

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Docker Thymeleaf</title>
</head>
<body>
    <h1 th:text="${message}">Hello Placeholder</h1>
</body>
</html>
```

---

## 🧰 Build Aplikasi

Jalankan perintah berikut di terminal:

```bash
./mvnw clean package
```

Ini akan menghasilkan file `.jar` di folder `target/`, misalnya:

```
target/dockerthymeleaf-0.0.1-SNAPSHOT.jar
```

---

## 🐋 Membuat Dockerfile

Buat file `Dockerfile` di root project:

```Dockerfile
FROM eclipse-temurin:17-jdk-alpine
LABEL maintainer="your.email@example.com"
WORKDIR /app
COPY target/dockerthymeleaf-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 🔥 Build Docker Image

```bash
docker build -t springboot-hello-app .
```

---

## 🚦 Jalankan Container

```bash
docker run -p 8080:8080 springboot-hello-app
```

---

## ✅ Uji Aplikasi

Akses di browser:

```
http://localhost:8080
```

Harusnya muncul halaman HTML dengan pesan:

```
Hello from Spring Boot with Thymeleaf and Docker!
```

---

## 📦 Tambahan (Opsional)

### .dockerignore

```
target/
.git
.mvn
.idea
*.iml
*.log
```

---

## 📌 Troubleshooting

* Pastikan folder `templates/` tidak hilang saat build
* Jika error `template not found`, periksa penempatan `index.html`
* Ganti port jika 8080 bentrok

---

## 🔄 Update Docker Image

Jika kamu melakukan perubahan pada source code atau HTML dan ingin membangun ulang image:

```bash
./mvnw clean package

docker build -t springboot-hello-app .
```

Jika container masih berjalan, stop dulu dengan:

```bash
docker ps
```

Cari `CONTAINER ID`, lalu:

```bash
docker stop <CONTAINER_ID>
docker rm <CONTAINER_ID>
```

Kemudian jalankan ulang:

```bash
docker run -p 8080:8080 springboot-hello-app
```

---

## 📚 Referensi

* [Spring Boot Docs](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/)
* [Docker Docs](https://docs.docker.com/)
* [Thymeleaf Docs](https://www.thymeleaf.org/)

---

## 🔖 Lisensi

Proyek ini bebas digunakan untuk keperluan belajar dan pengembangan.
