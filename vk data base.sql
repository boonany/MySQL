drop database vk;
create database vk;

use vk;

/* Эта таблица сожержит авторизационные данные (кроме паролей), версионная */ 
create table users (
	id INT UNSIGNED NOT NULL auto_increment primary key  comment "Идентификатор строки",
	email varchar(100) not null unique comment "Почта",
	phone varchar(100) not null unique comment "Телефон",
	created_at datetime default current_timestamp comment "Вермя создания строки",
	update_at datetime default current_timestamp on update current_timestamp comment "Время обновления строки" 
);

DROP TABLE IF EXISTS profiles;
-- Таблица профилей с личными данными пользователя. Версионная 
CREATE TABLE profiles (
	id INT UNSIGNED NOT NULL auto_increment primary key  comment "Идентификатор строки",
    user_id int unsigned not null  comment "Идентификатор пользователя",
	first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
	last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
    gender varchar(1) NOT NULL COMMENT "Пол",
    birthday DATE COMMENT "Дата Рождения",
    city VARCHAR(130) COMMENT "Город проживания",
    country varchar(130) COMMENT "Страна проживания",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
    );
    
SHOW TABLES;
    
ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);
	
    


CREATE TABLE communities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
    );
    
/* Таблица связи групп и пользователей */
CREATE TABLE communities_users (
	community_id INT UNSIGNED NOT NULL COMMENT "Идентификатор группы",
    user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
    );

ALTER TABLE communities_users ADD CONSTRAINT pk_communities_users PRIMARY KEY (community_id, user_id);

-- Создаем внешние ключи для связи таблицы "communities_users" с таблицами "communities" и "users"
ALTER TABLE communities_users ADD CONSTRAINT fk_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_com_user_id FOREIGN KEY (user_id) REFERENCES users(id);

/* Таблица для оттобржаения связи пользоватлей (друг/подписчик). Версионная */    
CREATE TABLE friendship (
	user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
    friend_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
    `status` VARCHAR(100) NOT NULL COMMENT "Тип отношений",
    request_at DATETIME DEFAULT NOW() COMMENT "Время отправления пригладения дружить",
	confirmed_at DATETIME COMMENT "Время подтверделния запроса",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
    );
    
ALTER TABLE friendship ADD CONSTRAINT pk_friendship PRIMARY KEY (user_id,friend_id);
ALTER TABLE friendship ADD CONSTRAINT fk__fr_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

/* Таблица сообщений между пользователямию Версионная */
CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	sender_id INT UNSIGNED NOT NULL COMMENT "Идентификатор отправителя",
	reciver_id INT UNSIGNED NOT NULL COMMENT "Идентификатор получателя",
    send_at DATETIME DEFAULT NOW() COMMENT "Время отправления сообщения",
	recived_at DATETIME COMMENT "Время получения сообщения",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

ALTER TABLE messages ADD CONSTRAINT fk_sender_id FOREIGN KEY (sender_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_recivier_id FOREIGN KEY (reciver_id) REFERENCES users(id);

/* Таблица лайков для медиафайлов,постов и пользователей*/
CREATE TABLE likes (
	id  INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	entity_type_cd INT UNSIGNED NOT NULL COMMENT "id назвнания таблици, можно получить из entity_ident",
	entity_id INT UNSIGNED NOT NULL COMMENT "id медиафайла/ поста/ профиля в соответсвующей таблице",
	from_user_id INT UNSIGNED NOT NULL COMMENT  "id польщователя который поставил лайк",
	like_type_cd INT UNSIGNED NOT NULL COMMENT  " тип лайка лайк/дизлайк",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

CREATE TABLE entity_types (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
    entity_name VARCHAR(100)  NOT NULL UNIQUE COMMENT "Имя лайкабильной сущности"
);

CREATE TABLE like_types (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
    like_type_name VARCHAR(100)  NOT NULL UNIQUE COMMENT "Названия варианта лайка"
);

ALTER TABLE likes ADD CONSTRAINT fk_l_entity_type_id FOREIGN KEY (entity_type_cd) REFERENCES entity_types(id);
ALTER TABLE likes ADD CONSTRAINT fk_l_like_type_id FOREIGN KEY (like_type_cd) REFERENCES like_types(id);

CREATE TABLE posts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор поста",
	post_content TEXT COMMENT "Текст произвольной длины",
    user_id INT UNSIGNED COMMENT "Идентификатор пользователя который опубликовал пост",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	community_id INT UNSIGNED COMMENT "Идентификатор сообщества который опубликовал пост"
);

ALTER TABLE posts ADD CONSTRAINT fk_p_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT fk_p_community_id FOREIGN KEY (community_id) REFERENCES communities(id);

/* Таблица медиа */
CREATE TABLE media (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	media_type_id INT UNSIGNED NOT NULL COMMENT "Ижентификатор типа  типа контента",
    metadata JSON COMMENT "Комментарий пользователя к записи",
    filename VARCHAR(1000) NOT NULL COMMENT "Путь к файлу",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"	
);

CREATE TABLE media_types (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
    media_type_name VARCHAR(100)  NOT NULL UNIQUE COMMENT "Тип медиафайла"
);

ALTER TABLE media ADD CONSTRAINT fk_media_type_id FOREIGN KEY (media_type_id) REFERENCES media_types(id);

CREATE TABLE posts_media (
	post_id INT UNSIGNED NOT NULL COMMENT "Идентификатор группы",
    media_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
    );
     
ALTER TABLE posts_media  ADD CONSTRAINT pk_pm_post_media PRIMARY KEY (post_id,media_id);
ALTER TABLE posts_media  ADD CONSTRAINT fk_pm_post_id FOREIGN KEY (post_id) REFERENCES posts(id);
ALTER TABLE posts_media  ADD CONSTRAINT fk_pm_media_id FOREIGN KEY (media_id) REFERENCES media(id);


    CREATE TABLE messages_media (
	message_id INT UNSIGNED NOT NULL COMMENT "Идентификатор группы",
    media_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
    );
    
ALTER TABLE messages_media  ADD CONSTRAINT pk_mm_message_media PRIMARY KEY (message_id,media_id);
ALTER TABLE messages_media  ADD CONSTRAINT fk_mm_message_id FOREIGN KEY (message_id) REFERENCES messages(id);
ALTER TABLE messages_media  ADD CONSTRAINT fk_mm_media_id FOREIGN KEY (media_id) REFERENCES media(id);


