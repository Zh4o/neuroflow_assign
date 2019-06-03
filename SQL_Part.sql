WITH
T1 AS (
SELECT COUNT(DISTINCT user_id),
		to_char(created_at, 'Mon') as Mon,
        extract (year from created_at) as Yr
FROM users NATURAL JOIN exercises
WHERE created_at + interval '30 days' >= exercise_completion_date 
GROUP BY to_char(created_at, 'Mon'), extract (year from created_at)

UNION ALL

SELECT DISTINCT 0,
       to_char(created_at, 'Mon') as Mon,
       extract (year from created_at) as Yr
FROM users NATURAL JOIN exercises
WHERE NOT EXISTS (SELECT 1 FROM users NATURAL JOIN exercises WHERE created_at + interval '30 days' >= exercise_completion_date)
)
,
T2 AS (
SELECT COUNT(DISTINCT user_id),
		to_char(created_at, 'Mon') as Mon,
        extract (year from created_at) as Yr
FROM users
GROUP BY to_char(created_at, 'Mon'), extract (year from created_at)
)

SELECT T2.Mon, T2.Yr, CAST(T1.count AS FLOAT) / CAST(T2.count AS FLOAT) * 100 AS percent_completed_exercise
FROM T1, T2;



                                            