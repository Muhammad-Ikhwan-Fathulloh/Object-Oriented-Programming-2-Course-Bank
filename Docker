# Materi: Pengenalan dan Implementasi Deployment Spring Boot dengan Docker

---

## 1. Pengenalan Docker

Docker adalah platform open-source yang memungkinkan pengembang untuk mengemas aplikasi dan seluruh dependensinya ke dalam satu unit yang disebut container. Dengan container, aplikasi dapat dijalankan secara konsisten di berbagai lingkungan, baik di komputer lokal, server, maupun cloud.

### Keunggulan Docker:

* Portabilitas
* Konsistensi lingkungan
* Skalabilitas
* Efisiensi sumber daya

---

## 2. Mengapa Docker untuk Spring Boot?

Spring Boot adalah framework Java yang sering digunakan untuk membuat aplikasi backend RESTful. Digabungkan dengan Docker, Spring Boot menjadi sangat mudah di-deploy dan diskalakan.

Manfaat:

* Mudah dikembangkan dan diuji secara lokal
* Dapat dipindahkan ke berbagai platform cloud
* Mendukung integrasi pipeline CI/CD

---

## 3. Membuat Aplikasi Spring Boot Sederhana

### Struktur Project

```
springboot-docker/
├── src/
│   └── main/
│       └── java/
│           └── com/example/demo/
│               └── DemoApplication.java
├── pom.xml
└── Dockerfile
```

### File: `DemoApplication.java`

```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class DemoApplication {

    @GetMapping("/")
    public String hello() {
        return "Hello from Dockerized Spring Boot!";
    }

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

### File: `pom.xml`

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" ...>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>demo</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
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

## 4. Membuat Dockerfile

### File: `Dockerfile`

```dockerfile
# Gunakan base image Java
FROM openjdk:17-alpine

# Tentukan working directory
WORKDIR /app

# Salin file jar
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8080

# Jalankan aplikasi
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 5. Build dan Jalankan Docker secara Lokal

```bash
# Build project Spring Boot
./mvnw clean package

# Build Docker image
docker build -t springboot-demo .

# Jalankan container
docker run -p 8080:8080 springboot-demo
```

Akses aplikasi di `http://localhost:8080`

---

## 6. Push Image ke Docker Hub

```bash
docker tag springboot-demo yourdockerhubusername/springboot-demo
docker push yourdockerhubusername/springboot-demo
```

---

## 7. Deploy ke Cloud: Koyeb

### Langkah-langkah:

1. Buka [https://www.koyeb.com](https://www.koyeb.com)
2. Login dan buat **Service** baru
3. Pilih source "Docker Image"
4. Masukkan image: `yourdockerhubusername/springboot-demo`
5. Pilih region dan port (8080)
6. Klik **Deploy**

Akses aplikasi menggunakan domain yang diberikan oleh Koyeb.

---

## 8. Menyambungkan dengan Remote Database: FreeDB.tech

### Langkah:

1. Buka [https://freedb.tech](https://freedb.tech)
2. Daftar dan buat database
3. Catat host, port, username, dan password

### Tambahkan di `application.properties`

```properties
spring.datasource.url=jdbc:mysql://sql.freedb.tech:3306/freedb_namaDB
spring.datasource.username=freedb_user
spring.datasource.password=password_anda
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
```

### Tambahkan dependency di `pom.xml`

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```

---

## 9. Tips Lanjutan

* Gunakan `.env` untuk mengelola konfigurasi rahasia
* Tambahkan endpoint health check
* Gunakan CI/CD tools (GitHub Actions, GitLab CI) untuk deploy otomatis ke Koyeb
* Tambahkan file `.dockerignore` untuk mempercepat build:

```dockerignore
target/
.git/
*.md
```

---

## 10. Referensi

* [Spring Boot Docs](https://spring.io/projects/spring-boot)
* [Docker Docs](https://docs.docker.com/)
* [Koyeb Docs](https://docs.koyeb.com/)
* [FreeDB.tech](https://freedb.tech)
