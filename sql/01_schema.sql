-- MySQL 전용 설정: 데이터베이스 생성 및 선택
CREATE DATABASE IF NOT EXISTS book_rental;
USE book_rental;

-- 1. 회원
CREATE TABLE member (
    member_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- 2. 카테고리
CREATE TABLE category (
    category_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- 3. 도서
CREATE TABLE book (
    book_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,

    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- 4. 대여 기록
CREATE TABLE rental (
    rental_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    rental_date DATE NOT NULL,
    return_date DATE,

    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);