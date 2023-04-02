-- 1. Создайте представление, в которое попадет информация о  пользователях (имя, фамилия, город и пол), которые не старше 20 лет.

CREATE VIEW young_users_info AS
SELECT u.first_name, u.last_name, p.hometown, p.gender
FROM users u
JOIN profiles p ON u.id = p.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, CURDATE()) <= 20;

-- 2. Найдите кол-во,  отправленных сообщений каждым пользователем и  выведите ранжированный список пользователей, указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)

SELECT CONCAT(users.first_name, ' ', users.last_name) AS name,
       COUNT(messages.id) AS message_count,
       DENSE_RANK() OVER (ORDER BY COUNT(messages.id) DESC) AS ranking
FROM users
LEFT JOIN messages ON users.id = messages.sender_id
GROUP BY users.id
ORDER BY ranking;

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
SELECT id, created_at, LAG(created_at) OVER (ORDER BY created_at) AS previous_created_at,
       created_at - LAG(created_at) OVER (ORDER BY created_at) AS time_diff
FROM messages
ORDER BY created_at ASC;