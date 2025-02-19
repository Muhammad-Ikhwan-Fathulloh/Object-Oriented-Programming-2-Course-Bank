# **Silabus: Pemrograman Berorientasi Obyek 2 dengan Spring Boot (14 Pertemuan)**

## **📌 SILABUS PBO 2 - JAVA SPRING BOOT API + JAVASCRIPT NATIVE (14 PERTEMUAN)**  
_(Pemrograman Berorientasi Objek Lanjutan dengan Java Spring Boot untuk Backend API & JavaScript Native untuk Frontend)_

---

### **📖 Deskripsi Mata Kuliah**  
Mata kuliah ini membahas **Pemrograman Berorientasi Objek (PBO) Lanjutan** dengan implementasi **Spring Boot** untuk membangun **REST API** serta **JavaScript Native** untuk frontend tanpa framework. Proses pengembangan akan dilakukan menggunakan **Visual Studio Code** sebagai IDE, dengan konsep **microservice architecture**.

**📌 Prasyarat:**  
✅ Memahami dasar-dasar Java dan Pemrograman Berorientasi Objek (PBO 1)  
✅ Memahami dasar-dasar HTML, CSS, dan JavaScript  
✅ Memahami konsep REST API dan komunikasi client-server  

---

## **📅 Rencana 14 Pertemuan**
| **Minggu** | **Materi** | **Praktikum** |
|------------|-----------|--------------|
| **1** | **Pengenalan Spring Boot & Arsitektur Microservice** | Setup Spring Boot dan konfigurasi PostgreSQL/MySQL |
| **2** | **Review OOP (Encapsulation, Inheritance, Polymorphism, Abstraction) di Java** | Implementasi konsep OOP dalam Spring Boot |
| **3** | **Membuat REST API dengan Spring Boot** | Endpoint pertama dengan `@RestController` |
| **4** | **CRUD API dengan Spring Boot (Create, Read, Update, Delete)** | Implementasi CRUD dengan `@RestController` dan `JPA` |
| **5** | **Membuat Frontend dengan HTML, CSS, dan JavaScript Native** | Fetch API dari backend dengan JavaScript |
| **6** | **Menghubungkan API dengan Frontend** | Implementasi AJAX menggunakan `fetch` |
| **7** | **Autentikasi API dengan Spring Security (JWT)** | Login & proteksi API dengan JWT |
| **8** | **Validasi Data & Error Handling** | Implementasi validasi input dan error handling |
| **9** | **Optimasi Database dengan Query & Indexing** | Optimasi query pada Spring Data JPA |
| **10** | **Optimasi API Response** | Implementasi caching sederhana |
| **11** | **Deploy Spring Boot API dengan Docker & Koyeb** | Deployment backend API |
| **12** | **Keamanan API (XSS, SQL Injection, CSRF)** | Implementasi keamanan di backend & frontend |
| **13** | **Finalisasi Proyek API & Frontend** | Integrasi semua fitur |
| **14** | **Presentasi dan Evaluasi Proyek** | Deployment final dan evaluasi proyek |

---

## **📌 Detail Setiap Pertemuan dengan Contoh Kode**
### **📌 1. Pengenalan Spring Boot & Arsitektur Monolith**
✅ **Instalasi dan Konfigurasi**  
- Install **JDK 17**, **Spring Boot**, dan **PostgreSQL/MySQL**  
- Setup **Visual Studio Code** dengan ekstensi Java  
- Struktur folder proyek Spring Boot  

✅ **Menjalankan Spring Boot**
```sh
mvn spring-boot:run
```

✅ **Contoh `application.properties`**
```properties
server.port=8080
spring.datasource.url=jdbc:mysql://localhost:3306/app
spring.datasource.username=root
spring.datasource.password=12345
spring.jpa.hibernate.ddl-auto=update
```

---

### **📌 2. Review OOP di Java**
✅ **Encapsulation, Inheritance, Polymorphism, Abstraction**
```java
public class User {
    private String username;
    public void setUsername(String username) { this.username = username; }
    public String getUsername() { return username; }
}
```

---

### **📌 3. Membuat REST API dengan Spring Boot**
✅ **Membuat REST Controller**
```java
@RestController
@RequestMapping("/api")
public class UserController {
    @GetMapping("/hello")
    public String hello() { return "Hello, World!"; }
}
```

---

### **📌 4. CRUD API dengan Spring Boot**
✅ **Entity & Repository**
```java
@Entity
public class User {
    @Id @GeneratedValue private Long id;
    private String username;
}
public interface UserRepository extends JpaRepository<User, Long> {}
```

✅ **Service & Controller**
```java
@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired private UserRepository userRepository;
    @PostMapping public User createUser(@RequestBody User user) {
        return userRepository.save(user);
    }
}
```

---

### **📌 5. Membuat Frontend dengan JavaScript Native**
✅ **HTML Form**
```html
<input type="text" id="username">
<button onclick="submitUser()">Submit</button>
```

✅ **JavaScript Fetch API**
```js
async function submitUser() {
    let username = document.getElementById('username').value;
    let response = await fetch('/users', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ username })
    });
    let data = await response.json();
    console.log(data);
}
```

---

### **📌 6. Menghubungkan API dengan Frontend**
✅ **Menampilkan Data dari API**
```js
async function loadUsers() {
    let response = await fetch('/users');
    let users = await response.json();
    document.getElementById('userList').innerHTML = users.map(u => `<li>${u.username}</li>`).join('');
}
```

---

### **📌 7. Autentikasi API dengan Spring Security (JWT)**
✅ **JWT Authentication**
```java
@Bean public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http.csrf().disable().authorizeRequests().anyRequest().authenticated().and().httpBasic();
    return http.build();
}
```

✅ **Login API**
```java
@PostMapping("/login")
public String login(@RequestBody User user) { return jwtService.generateToken(user); }
```

---

### **📌 8. Validasi Data & Error Handling**
✅ **Validasi dengan Spring Boot**
```java
@PostMapping public User createUser(@Valid @RequestBody User user) {
    return userRepository.save(user);
}
```

---

### **📌 9. Optimasi Database dengan Query & Indexing**
✅ **Optimasi Query**
```java
@Query("SELECT u FROM User u WHERE u.username = :username")
List<User> findByUsername(@Param("username") String username);
```

---

### **📌 10. Optimasi API Response & Caching**
✅ **Implementasi Caching**
```java
@Cacheable("users")
public List<User> getAllUsers() { return userRepository.findAll(); }
```

---

### **📌 11. Deploy Spring Boot API dengan Docker & Koyeb**
✅ **Dockerfile**
```dockerfile
FROM openjdk:17
COPY target/app.jar app.jar
CMD ["java", "-jar", "app.jar"]
```

✅ **Deploy ke Koyeb**
```sh
koyeb service create spring-boot-api --docker ghcr.io/user/repo:latest
```

---

### **📌 12. Keamanan API (XSS, SQL Injection, CSRF)**
✅ **Mencegah SQL Injection**
```java
@Query("SELECT u FROM User u WHERE u.username = :username")
List<User> findUser(@Param("username") String username);
```

✅ **CORS Configuration**
```java
@Bean public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
        @Override public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**").allowedOrigins("*");
        }
    };
}
```

---

### **📌 13. Finalisasi Proyek API & Frontend**
✅ **Testing API dengan Postman**  
✅ **Penyempurnaan fitur CRUD dan autentikasi**  

---

### **📌 14. Presentasi dan Evaluasi Proyek**
✅ **Presentasi hasil proyek**  
✅ **Evaluasi kode dan deployment**  

---
