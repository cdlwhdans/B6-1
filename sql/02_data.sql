USE book_rental;

-- 1. 회원 10명
INSERT INTO member (member_id, name, email) VALUES
(1, '김민수', 'minsu@example.com'),
(2, '이서연', 'seoyeon@example.com'),
(3, '박지훈', 'jihun@example.com'),
(4, '최유진', 'yujin@example.com'),
(5, '정현우', 'hyunwoo@example.com'),
(6, '강수빈', 'subin@example.com'),
(7, '조지우', 'jiwoo@example.com'),
(8, '윤도현', 'dohyun@example.com'),
(9, '장예린', 'yerin@example.com'),
(10, '임준호', 'junho@example.com');

-- 2. 카테고리 10개
INSERT INTO category (category_id, name) VALUES
(1, '소설'),
(2, '시'),
(3, '에세이'),
(4, '역사'),
(5, '과학'),
(6, '컴퓨터'),
(7, '경제'),
(8, '자기계발'),
(9, '여행'),
(10, '예술');

-- 3. 도서 10권
INSERT INTO book (book_id, title, category_id) VALUES
(1, '봄날의 이야기', 1),
(2, '별을 읽는 밤', 2),
(3, '일상의 기록', 3),
(4, '한국사 첫걸음', 4),
(5, '생활 속 과학', 5),
(6, '파이썬 입문', 6),
(7, 'SQL 입문', 6),
(8, '경제의 기초', 7),
(9, '작은 습관', 8),
(10, '제주 여행 안내서', 9);

-- 4. 대여 기록 10건
-- return_date가 NULL이면 아직 반납하지 않은 상태
INSERT INTO rental (
    rental_id, member_id, book_id, rental_date, return_date
) VALUES
(1, 1, 1, '2026-10-01', '2026-10-05'),
(2, 1, 6, '2026-10-03', '2026-10-10'),
(3, 2, 7, '2026-10-05', '2026-10-12'),
(4, 3, 2, '2026-10-07', '2026-10-09'),
(5, 4, 3, '2026-10-10', '2026-10-15'),
(6, 5, 4, '2026-10-15', NULL),
(7, 6, 5, '2026-10-18', NULL),
(8, 7, 8, '2026-10-20', NULL),
(9, 8, 9, '2026-10-22', NULL),
(10, 2, 1, '2026-10-25', NULL);