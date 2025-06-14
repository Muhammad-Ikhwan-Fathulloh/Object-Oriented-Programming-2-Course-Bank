# 📚 Materi: Spring Boot JPA Join Multi Tabel

---

## 🧠 Konsep Dasar
Join multi tabel dibutuhkan ketika data tersebar dalam beberapa tabel, misalnya:
- Mahasiswa memiliki satu jurusan (`ManyToOne`)
- Mahasiswa memiliki satu alamat (`OneToOne`)

Dengan JPA (Java Persistence API), relasi ini bisa dimodelkan menggunakan anotasi yang sesuai, dan query join bisa dilakukan baik secara otomatis melalui fetch relasi maupun menggunakan JPQL atau native SQL.

---

## 🏛️ Struktur Tabel dan Relasi

### 🧾 Tabel: `jurusan`

| id | nama_jurusan        |
|----|---------------------|
| 1  | Teknik Informatika  |
| 2  | Sistem Informasi    |

---

### 🧾 Tabel: `alamat`

| id | kota      | provinsi     |
|----|-----------|--------------|
| 1  | Bandung   | Jawa Barat   |
| 2  | Surabaya  | Jawa Timur   |

---

### 🧾 Tabel: `mahasiswa`

| id | nama   | nim        | jurusan_id | alamat_id |
|----|--------|------------|------------|-----------|
| 1  | Tekno | 123456789  | 1          | 1         |
| 2  | Tekna | 987654321  | 2          | 2         |

---

### 🔗 Relasi

- `mahasiswa.jurusan_id` → `jurusan.id` (Many-to-One)
- `mahasiswa.alamat_id` → `alamat.id` (Many-to-One)

### SQL: Buat Tabel
```sql
CREATE TABLE jurusan (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nama_jurusan VARCHAR(100)
);

CREATE TABLE alamat (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    kota VARCHAR(100),
    provinsi VARCHAR(100)
);

CREATE TABLE mahasiswa (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(100),
    nim VARCHAR(20),
    jurusan_id BIGINT,
    alamat_id BIGINT,
    FOREIGN KEY (jurusan_id) REFERENCES jurusan(id),
    FOREIGN KEY (alamat_id) REFERENCES alamat(id)
);
```

### Contoh Data
```sql
INSERT INTO jurusan (nama_jurusan) VALUES ('Teknik Informatika'), ('Sistem Informasi');
INSERT INTO alamat (kota, provinsi) VALUES ('Bandung', 'Jawa Barat'), ('Surabaya', 'Jawa Timur');
INSERT INTO mahasiswa (nama, nim, jurusan_id, alamat_id) 
VALUES ('Tekno', '123456789', 1, 1), ('Tekna', '987654321', 2, 2);
```

---

## ⚙️ Query SQL Manual
```sql
SELECT m.nama, m.nim, j.nama_jurusan, a.kota, a.provinsi
FROM mahasiswa m
JOIN jurusan j ON m.jurusan_id = j.id
JOIN alamat a ON m.alamat_id = a.id;
```

---

## 🚀 Implementasi Spring Boot

### 1. Entity: Jurusan
```java
@Entity
public class Jurusan {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String namaJurusan;
    // Getter & Setter
}
```

### 2. Entity: Alamat
```java
@Entity
public class Alamat {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String kota;
    private String provinsi;
    // Getter & Setter
}
```

### 3. Entity: Mahasiswa
```java
@Entity
public class Mahasiswa {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nama;
    private String nim;

    @ManyToOne
    @JoinColumn(name = "jurusan_id")
    private Jurusan jurusan;

    @OneToOne
    @JoinColumn(name = "alamat_id")
    private Alamat alamat;
    // Getter & Setter
}
```

---

## 📦 DTO (Data Transfer Object)
```java
public class MahasiswaDTO {
    private String nama;
    private String nim;
    private String namaJurusan;
    private String kota;
    private String provinsi;

    public MahasiswaDTO(String nama, String nim, String namaJurusan, String kota, String provinsi) {
        this.nama = nama;
        this.nim = nim;
        this.namaJurusan = namaJurusan;
        this.kota = kota;
        this.provinsi = provinsi;
    }
    // Getter
}
```

---

## 📁 Repository
```java
@Repository
public interface MahasiswaRepository extends JpaRepository<Mahasiswa, Long> {
    @Query("SELECT new com.namaaplikasi.dto.MahasiswaDTO(m.nama, m.nim, j.namaJurusan, a.kota, a.provinsi) " +
           "FROM Mahasiswa m JOIN m.jurusan j JOIN m.alamat a")
    List<MahasiswaDTO> findAllMahasiswaWithJoin();
}
```

---

## 🌐 Controller
```java
@RestController
@RequestMapping("/api/mahasiswa")
public class MahasiswaController {

    @Autowired
    private MahasiswaRepository mahasiswaRepository;

    @GetMapping("/join")
    public List<MahasiswaDTO> getAllWithJoin() {
        return mahasiswaRepository.findAllMahasiswaWithJoin();
    }
}
```

---

## 📌 Output JSON
```json
[
  {
    "nama": "Tekno",
    "nim": "123456789",
    "namaJurusan": "Teknik Informatika",
    "kota": "Bandung",
    "provinsi": "Jawa Barat"
  },
  {
    "nama": "Tekna",
    "nim": "987654321",
    "namaJurusan": "Sistem Informasi",
    "kota": "Surabaya",
    "provinsi": "Jawa Timur"
  }
]
```

---

## 📘 Tips Tambahan
- Gunakan `LEFT JOIN` jika relasi opsional
- Gunakan `@EntityGraph` untuk optimisasi fetch join
- Pertimbangkan pagination dan sort pada query kompleks
- Gunakan Projections (interface-based DTO) jika ingin efisiensi lebih tinggi
