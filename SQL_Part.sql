WITH
T1 AS (
SELECT COUNT(DISTINCT user_id),
		to_char(created_at, 'Month') as Mon,
        extract (year from created_at) as Yr
FROM users NATURAL JOIN exercises
WHERE created_at + interval '30 days' >= exercise_completion_date 
GROUP BY to_char(created_at, 'Month'), extract (year from created_at)

UNION ALL

select DISTINCT 0,
       to_char(created_at, 'Month') as Mon,
       extract (year from created_at) as Yr
FROM users NATURAL JOIN exercises
WHERE NOT EXISTS (SELECT 1 FROM users NATURAL JOIN exercises WHERE created_at + interval '30 days' >= exercise_completion_date)
)
,
T2 AS (
SELECT COUNT(DISTINCT user_id),
		to_char(created_at, 'Month') as Mon,
        extract (year from created_at) as Yr
FROM users
GROUP BY to_char(created_at, 'Month'), extract (year from created_at)
)

SELECT T2.Mon, T2.Yr, COALESCE(CAST(T1.count AS FLOAT) / CAST(T2.count AS FLOAT) * 100, 0) AS percent_completed_exercise
FROM T1 RIGHT OUTER JOIN T2 ON T2.Mon = T1.Mon AND T2.Yr = T1.Yr;
ORDER BY to_date(T2.Mon, 'Month'), T2.Yr DESC;