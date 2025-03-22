-- Buat database jika belum ada
CREATE DATABASE IF NOT EXISTS todo_db;

-- Gunakan database yang baru dibuat
USE todo_db;

-- Buat tabel todos
CREATE TABLE IF NOT EXISTS todos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    task VARCHAR(255) NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE
);
