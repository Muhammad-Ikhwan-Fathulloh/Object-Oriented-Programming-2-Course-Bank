Berikut adalah **penjelasan lengkap** tentang pembuatan aplikasi **To-Do List dengan Spring Boot, Thymeleaf, dan MySQL**, termasuk penjabaran dari setiap langkah beserta alasan dan fungsinya.

---

## 🎯 **Tujuan Proyek**
Membuat aplikasi _To-Do List_ sederhana berbasis web, yang memungkinkan pengguna untuk:
- Menambah tugas baru
- Melihat daftar tugas
- Menandai tugas sebagai selesai
- Menghapus tugas

Dengan menggunakan **Spring Boot** sebagai backend, **Thymeleaf** sebagai template engine frontend, dan **MySQL** sebagai database.

---

## 1. ✅ **Setup Proyek Spring Boot**
Gunakan Spring Initializr untuk membuat kerangka proyek dengan dependensi:

| Dependency | Fungsi |
|-----------|--------|
| **Spring Web** | Menyediakan kemampuan untuk membuat aplikasi berbasis web dan RESTful. |
| **Thymeleaf** | Template engine untuk menghasilkan HTML dinamis di sisi server. |
| **Spring Boot DevTools** | Mempercepat pengembangan dengan _hot reload_. |
| **Spring Data JPA** | Menyederhanakan interaksi dengan database menggunakan ORM. |
| **MySQL Driver** | Driver JDBC untuk koneksi ke database MySQL. |

> Alternatif CLI:
```bash
spring init --name=spring-todo --dependencies=web,thymeleaf,jpa,mysql,devtools spring-todo
```

---

## 2. ⚙️ **Konfigurasi Koneksi Database**

Edit `application.properties` agar aplikasi bisa terhubung ke database MySQL:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/todo_db?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=yourpassword
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### Penjelasan:
- `ddl-auto=update`: Hibernate akan membuat/memperbarui tabel secara otomatis.
- `show-sql=true`: Menampilkan query SQL di konsol.

> Pastikan database `todo_db` telah dibuat sebelumnya di MySQL.

---

## 3. 🧱 **Buat Model ToDo (Entity)**

```java
@Entity
@Table(name = "todos")
public class ToDo {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String task;
    private boolean completed;

    // Konstruktor, Getter, Setter
}
```

### Penjelasan:
- `@Entity`: Menandakan bahwa ini adalah model untuk tabel database.
- `@Table`: Nama tabel di database.
- `@Id` dan `@GeneratedValue`: `id` sebagai primary key dan akan otomatis terisi (auto increment).

---

## 4. 🗃️ **Buat Repository**

```java
@Repository
public interface ToDoRepository extends JpaRepository<ToDo, Long> {
}
```

### Penjelasan:
- Menggunakan `JpaRepository`, kita bisa menggunakan fungsi-fungsi bawaan seperti `findAll()`, `save()`, `deleteById()`, dll tanpa implementasi manual.

---

## 5. ⚙️ **Buat Service Layer**

```java
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

### Penjelasan:
- Layer ini menangani logika bisnis.
- Memisahkan controller dari logika database.
- `Optional<ToDo>` digunakan untuk menghindari `NullPointerException`.

---

## 6. 🎮 **Buat Controller**

```java
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

### Penjelasan:
- `@GetMapping` menampilkan halaman utama.
- `@PostMapping("/add")` menambahkan tugas baru.
- `@PostMapping("/delete/{id}")` menghapus tugas berdasarkan ID.
- `@PostMapping("/update/{id}")` menandai tugas selesai / belum selesai.

---

## 7. 🖼️ **Buat Template HTML (Thymeleaf)**

**`index.html`**:
```html
<!DOCTYPE html>
<html lang="id" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>To-Do List</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <h1>To-Do List</h1>

    <form action="/add" method="post">
        <input type="text" name="task" required>
        <button type="submit">Tambah</button>
    </form>

    <ul>
        <li th:each="todo : ${todos}">
            <span th:text="${todo.task}" th:class="${todo.completed} ? 'completed' : ''"></span>

            <form th:action="@{'/update/' + ${todo.id}}" method="post" style="display:inline;">
                <button type="submit">✔</button>
            </form>

            <form th:action="@{'/delete/' + ${todo.id}}" method="post" style="display:inline;">
                <button type="submit">❌</button>
            </form>
        </li>
    </ul>

    <script src="/js/script.js"></script>
</body>
</html>
```

### Penjelasan:
- `th:each`: Melakukan perulangan list todo.
- `th:text`: Menampilkan teks tugas.
- `th:class`: Menambahkan kelas CSS jika tugas sudah selesai.
- `th:action`: Membuat URL dinamis berdasarkan ID.

---

## 8. 🎨 **Tambahkan CSS untuk Tampilan**

**`style.css`**:
```css
body {
    font-family: Arial, sans-serif;
    text-align: center;
    padding: 2rem;
}

form {
    margin: 1rem 0;
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
    color: gray;
}
```

### Penjelasan:
Memberikan gaya minimalis untuk tampilan dan memberikan efek “dicoret” pada tugas yang sudah selesai.

---

## 9. 🚀 **Menjalankan Aplikasi**

Jalankan aplikasi dengan:

```bash
mvn spring-boot:run
# atau jika menggunakan Gradle:
./gradlew bootRun
```

Akses di browser:
```
http://localhost:8080
```

---

## 10. ✅ **Fitur yang Telah Dibuat**

| Fitur | Penjelasan |
|-------|------------|
| **Tambah To-Do** | Pengguna dapat menambahkan tugas baru melalui form. |
| **Tampilkan Daftar** | Semua tugas ditampilkan dalam daftar. |
| **Tandai Selesai** | Pengguna dapat menandai tugas sebagai selesai (✔). |
| **Hapus Tugas** | Pengguna dapat menghapus tugas (❌). |

---

## 11. 📚 **Struktur Folder**

```
spring-todo/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── controller/ToDoController.java
│   │   │   ├── service/ToDoService.java
│   │   │   ├── repository/ToDoRepository.java
│   │   │   └── model/ToDo.java
│   │   ├── resources/
│   │   │   ├── templates/index.html
│   │   │   ├── static/css/style.css
│   │   │   └── application.properties
├── pom.xml
```

---

## 12. 🔧 **Latihan**
- ✏️ Validasi input
- ✅ Filter tampilan: Semua / Selesai / Belum Selesai
- 📱 Responsive design (pakai Bootstrap)
- 📆 Tambahkan tanggal deadline

---
