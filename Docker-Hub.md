# 🐳 Deploy ke Docker Hub

## 1. Buat Akun Docker Hub

Jika belum memiliki akun, silakan daftar di:
👉 [https://hub.docker.com/](https://hub.docker.com/)

---

## 2. Login ke Docker Hub di Terminal

```bash
docker login
```

Masukkan **username** dan **password Docker Hub** kamu.

---

## 3. Tag Docker Image

Image yang kamu buat sebelumnya harus diberi nama dengan format:

```bash
docker tag springboot-hello-app <dockerhub-username>/springboot-hello-app:latest
```

Contoh:

```bash
docker tag springboot-hello-app ikhwanfathulloh/springboot-hello-app:latest
```

---

## 4. Push ke Docker Hub

```bash
docker build . -t <dockerhub-username>/springboot-hello-app
docker login
docker push <dockerhub-username>/springboot-hello-app
```

Contoh:

```bash
docker push ikhwanfathulloh/springboot-hello-app:latest
```

Tunggu sampai proses upload selesai.

---

## 5. Jalankan dari Docker Hub (Di Server Lain)

Jika kamu ingin menjalankan container dari image yang sudah ada di Docker Hub:

```bash
docker run -p 8080:8080 <dockerhub-username>/springboot-hello-app:latest
```

Contoh:

```bash
docker run -p 8080:8080 kangtekno/springboot-hello-app:latest
```

---

## 📂 Contoh Struktur Repository di Docker Hub

| Tag    | Ukuran | Update Terakhir |
| ------ | ------ | --------------- |
| latest | 100MB  | Just now        |

---

## 🔧 Tips Tambahan

* Gunakan `:v1`, `:v2` untuk menandai versi yang berbeda.
* Jangan lupa membuat file `README.md` di Docker Hub repository agar lebih informatif.

Contoh deskripsi singkat untuk Docker Hub:

> **Spring Boot Thymeleaf Docker App**
>
> A simple Spring Boot application using Thymeleaf, fully containerized with Docker.
>
> 🛠️ Quick Start:
>
> ```bash
> docker run -p 8080:8080 kangtekno/springboot-hello-app:latest
> ```
>
> 🔗 Access at: `http://localhost:8080`
