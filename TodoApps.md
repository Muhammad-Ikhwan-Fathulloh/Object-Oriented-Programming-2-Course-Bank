Berikut adalah panduan lengkap untuk membuat aplikasi **To-Do List** menggunakan **Spring Boot + Thymeleaf + MySQL**.

---

## **1. Setup Proyek Spring Boot**
Buat proyek Spring Boot menggunakan [Spring Initializr](https://start.spring.io/) dengan dependensi:
- **Spring Web**
- **Thymeleaf**
- **Spring Boot DevTools**
- **Spring Data JPA**
- **MySQL Driver**

Atau jalankan perintah:
```sh
spring init --name=spring-todo --dependencies=web,thymeleaf,jpa,mysql,devtools spring-todo
```

Setelah proyek dibuat, buka di **IDE** favoritmu.

---

## **2. Konfigurasi Database MySQL**
Edit `src/main/resources/application.properties`:

```properties
# Konfigurasi Database MySQL
spring.datasource.url=jdbc:mysql://localhost:3306/todo_db?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=yourpassword
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# Konfigurasi JPA
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```
> Gantilah `yourpassword` dengan password MySQL kamu. Pastikan database `todo_db` sudah dibuat.

---

## **3. Buat Model ToDo**
Buat file `src/main/java/com/example/demo/model/ToDo.java`:

```java
package com.example.demo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "todos")
public class ToDo {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String task;
    private boolean completed;

    public ToDo() {}

    public ToDo(String task, boolean completed) {
        this.task = task;
        this.completed = completed;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTask() {
        return task;
    }

    public void setTask(String task) {
        this.task = task;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }
}
```

---

## **4. Buat Repository**
Buat file `src/main/java/com/example/demo/repository/ToDoRepository.java`:

```java
package com.example.demo.repository;

import com.example.demo.model.ToDo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ToDoRepository extends JpaRepository<ToDo, Long> {
}
```

---

## **5. Buat Service**
Buat file `src/main/java/com/example/demo/service/ToDoService.java`:

```java
package com.example.demo.service;

import com.example.demo.model.ToDo;
import com.example.demo.repository.ToDoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ToDoService {

    @Autowired
    private ToDoRepository toDoRepository;

    public List<ToDo> getAllTodos() {
        return toDoRepository.findAll();
    }

    public void saveTodo(ToDo todo) {
        toDoRepository.save(todo);
    }

    public void deleteTodo(Long id) {
        toDoRepository.deleteById(id);
    }

    public Optional<ToDo> getTodoById(Long id) {
        return toDoRepository.findById(id);
    }
}
```

---

## **6. Buat Controller**
Buat file `src/main/java/com/example/demo/controller/ToDoController.java`:

```java
package com.example.demo.controller;

import com.example.demo.model.ToDo;
import com.example.demo.service.ToDoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/")
public class ToDoController {

    @Autowired
    private ToDoService toDoService;

    @GetMapping
    public String home(Model model) {
        model.addAttribute("todos", toDoService.getAllTodos());
        model.addAttribute("newTodo", new ToDo());
        return "index";
    }

    @PostMapping("/add")
    public String addTodo(@ModelAttribute ToDo todo) {
        toDoService.saveTodo(todo);
        return "redirect:/";
    }

    @PostMapping("/delete/{id}")
    public String deleteTodo(@PathVariable Long id) {
        toDoService.deleteTodo(id);
        return "redirect:/";
    }

    @PostMapping("/update/{id}")
    public String updateTodo(@PathVariable Long id) {
        Optional<ToDo> todo = toDoService.getTodoById(id);
        todo.ifPresent(t -> {
            t.setCompleted(!t.isCompleted());
            toDoService.saveTodo(t);
        });
        return "redirect:/";
    }
}
```

---

## **7. Buat Tampilan HTML**
Buat file `src/main/resources/templates/index.html`:

```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>To-Do List</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <h1>To-Do List</h1>

    <!-- Form Tambah ToDo -->
    <form action="/add" method="post">
        <input type="text" name="task" required>
        <button type="submit">Tambah</button>
    </form>

    <ul>
        <li th:each="todo : ${todos}">
            <span th:text="${todo.task}" th:class="${todo.completed} ? 'completed' : ''"></span>
            <form action="/update/{id}" method="post" style="display:inline;">
                <input type="hidden" name="id" th:value="${todo.id}">
                <button type="submit">✔</button>
            </form>
            <form action="/delete/{id}" method="post" style="display:inline;">
                <input type="hidden" name="id" th:value="${todo.id}">
                <button type="submit">❌</button>
            </form>
        </li>
    </ul>

    <script src="/js/script.js"></script>
</body>
</html>
```

---

## **8. Buat CSS untuk Tampilan**
Buat file `src/main/resources/static/css/style.css`:

```css
body {
    font-family: Arial, sans-serif;
    text-align: center;
}

ul {
    list-style: none;
    padding: 0;
}

li {
    margin: 10px 0;
}

.completed {
    text-decoration: line-through;
}
```

---

## **9. Jalankan Aplikasi**
Jalankan aplikasi dengan perintah:
```sh
mvn spring-boot:run
```
Atau jika menggunakan Gradle:
```sh
./gradlew bootRun
```

Akses di `http://localhost:8080`.

---

## **10. Penjelasan Fitur**
✅ **Menampilkan daftar To-Do**  
✅ **Menambahkan tugas baru**  
✅ **Menandai tugas sebagai selesai**  
✅ **Menghapus tugas**  
