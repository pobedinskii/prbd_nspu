/* Сколько минут записано каждым юзером */
SELECT User.userId, User.firstName, User.lastName, SUM(Record.duration) as `Total Minutes Recorded`, COUNT(*) as `Record Amount` FROM Record JOIN User on userId = Conference_User_userId GROUP BY Conference_User_userId;

/* Все сообщения от зарегистрированных юзеров */
SELECT User.userId, User.firstName, User.lastName, `text` FROM Message JOIN Participant ON participantId = Participant_participantId AND User_userId IS NOT NULL JOIN User ON userId = User_userId;

/* Количество сообщений в каждой конференции */
SELECT Conference.name, COUNT(*) as `Total Messages` FROM Message JOIN Conference ON Conference.createdAt = Conference_createdAt GROUP BY Conference.name;