USE book_rental;

-- [기본 조회 4개]

-- 01. 전체 회원을 회원 번호순으로 조회한다.
SELECT member_id, name, email
FROM member
ORDER BY member_id;

-- 02. 컴퓨터 카테고리의 도서를 조회한다.
SELECT book_id, title
FROM book
WHERE category_id = 6;

-- 03. 아직 반납하지 않은 대여 기록을 조회한다.
SELECT rental_id, member_id, book_id, rental_date
FROM rental
WHERE return_date IS NULL
ORDER BY rental_date;

-- 04. 최근 대여 기록 3건을 조회한다.
-- MySQL에서 지원하는 LIMIT 문법 사용
SELECT rental_id, member_id, book_id, rental_date
FROM rental
ORDER BY rental_date DESC, rental_id DESC
LIMIT 3;


-- [조인 4개]

-- 05. 도서 제목과 해당 카테고리 이름을 조회한다.
SELECT b.title, c.name AS category_name
FROM book AS b
INNER JOIN category AS c
    ON b.category_id = c.category_id
ORDER BY b.book_id;

-- 06. 대여 기록에 회원 이름을 연결해 조회한다.
SELECT r.rental_id, m.name, r.rental_date
FROM rental AS r
INNER JOIN member AS m
    ON r.member_id = m.member_id
ORDER BY r.rental_id;

-- 07. 대여 중인 도서 제목과 대여한 회원 이름을 조회한다.
SELECT m.name AS member_name, b.title, r.rental_date
FROM rental AS r
INNER JOIN member AS m
    ON r.member_id = m.member_id
INNER JOIN book AS b
    ON r.book_id = b.book_id
WHERE r.return_date IS NULL
ORDER BY r.rental_id;

-- 08. 대여 기록이 없는 회원도 포함해 모든 회원의 대여 기록을 조회한다.
SELECT m.member_id, m.name, r.rental_id, r.rental_date
FROM member AS m
LEFT JOIN rental AS r
    ON m.member_id = r.member_id
ORDER BY m.member_id, r.rental_id;


-- [집계 3개]

-- 09. 회원별 대여 횟수를 조회한다. 대여하지 않은 회원은 0으로 표시한다.
SELECT m.member_id, m.name, COUNT(r.rental_id) AS rental_count
FROM member AS m
LEFT JOIN rental AS r
    ON m.member_id = r.member_id
GROUP BY m.member_id, m.name
ORDER BY rental_count DESC, m.member_id;

-- 10. 카테고리별 도서 수를 조회한다. 도서가 없는 카테고리도 포함한다.
SELECT c.category_id, c.name, COUNT(b.book_id) AS book_count
FROM category AS c
LEFT JOIN book AS b
    ON c.category_id = b.category_id
GROUP BY c.category_id, c.name
ORDER BY c.category_id;

-- 11. 회원별 반납 완료 도서의 평균 대여 일수를 조회한다.
-- MySQL 전용 함수: DATEDIFF(종료일, 시작일)는 두 날짜의 차이를 일수로 반환
SELECT m.member_id, m.name,
       AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_days
FROM member AS m
INNER JOIN rental AS r
    ON m.member_id = r.member_id
WHERE r.return_date IS NOT NULL
GROUP BY m.member_id, m.name
ORDER BY m.member_id;


-- [서브쿼리 1개]

-- 12. 대여 기록이 없는 회원을 조회한다.
SELECT member_id, name
FROM member
WHERE member_id NOT IN (
    SELECT member_id
    FROM rental
)
ORDER BY member_id;


-- [수정 및 삭제 2개]
-- 수정·삭제 결과를 확인한 후 ROLLBACK으로 원래 데이터를 유지한다.

-- 13. 6번 대여 기록의 반납일을 수정하고 결과를 확인한다.
START TRANSACTION;

UPDATE rental
SET return_date = '2026-10-25'
WHERE rental_id = 6;

SELECT rental_id, member_id, book_id, rental_date, return_date
FROM rental
WHERE rental_id = 6;

ROLLBACK;

-- 14. 10번 대여 기록을 삭제하고 남은 대여 기록을 확인한다.
START TRANSACTION;

DELETE FROM rental
WHERE rental_id = 10;

SELECT rental_id, member_id, book_id, rental_date, return_date
FROM rental
ORDER BY rental_id;

ROLLBACK;


-- [인덱스 1개]

-- 15. 대여일 조건 검색과 날짜순 정렬에 활용할 인덱스를 생성한다.
CREATE INDEX idx_rental_date ON rental (rental_date);

-- MySQL 전용 명령: 생성된 인덱스 확인
SHOW INDEX FROM rental
WHERE Key_name = 'idx_rental_date';