#### The code can also be found at https://www.db-fiddle.com/f/ewM2RKh5jC67QAf8dwUfGt/1#&togetherjs=1So2Iu0Rja

I used Postgresql to complete this assignment.


To approach the query, I first drew out small examples on what the query what return. Then, to compare the created_at and exercise_completion_date, I knew a join was needed, so I chose to do a natural join, which removes rows where the user_id does not match, which means that user did not complete any exercise. 

Then I use the WHERE clause to check whether the exercise completion timestamp is at most 30 days from the created_at timestamp. Next, I grouped by the month and year after extracting them from the timestamp (https://stackoverflow.com/questions/17492167/group-query-results-by-month-and-year-in-postgresql). I realized that due to the where clause, the whole query may return a empty set, so I did a UNION ALL operation where if the WHERE clause returns an empty set, I make sure columns still existed and had 0, Mon, Date as the return value since the user could have completed an exercise more than 30 days after the their account has been created.

I then made another query to find the total number of distinct users, grouped by month and year. 

With the two subqueries in place, I did a final query which finds the percentage of users that completed an exercise in their cohort.



There are a few important assumptions I considered when making the query:
1. The user_id is a key in users and thus is unique
2. A user cannot log an exercise if the user_id has not yet been created (e.g. if the users table is empty, then the exercises table must be empty too)
3. I took "users that have a completed exercise in their first month for each cohort over months" as meaning they have completed an exercise less than or equal to 30 days since the user has been created


To test the query:

CREATE TABLE users (
  user_id INT,
  created_at TIMESTAMP,
  PRIMARY KEY(user_id)
);
INSERT INTO users (user_id, created_at) VALUES (1, '2018-01-14 16:42:26');
INSERT INTO users (user_id, created_at) VALUES (2, '2018-01-15 16:42:26');
INSERT INTO users (user_id, created_at) VALUES (3, '2018-01-16 16:42:26');
INSERT INTO users (user_id, created_at) VALUES (4, '2018-12-01 16:42:26');
INSERT INTO users (user_id, created_at) VALUES (5, '2019-01-01 16:42:26');

CREATE TABLE exercises(
  questionnaire_id INT,
  user_id INT REFERENCES users(user_id),
  exercise_completion_date TIMESTAMP
);

INSERT INTO exercises (questionnaire_id, user_id, exercise_completion_date) VALUES (1, 1, '2018-01-10 16:42:26');
INSERT INTO exercises (questionnaire_id, user_id, exercise_completion_date) VALUES (2, 1, '2018-02-13 16:42:26');
INSERT INTO exercises (questionnaire_id, user_id, exercise_completion_date) VALUES (3, 5, '2019-03-13 16:42:26');