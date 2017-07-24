-- 2 down
DROP TABLE IF EXISTS users;

-- 2 up

CREATE TABLE users (
    id       SERIAL PRIMARY KEY,
    username CHARACTER VARYING (255) UNIQUE,  
    email    CHARACTER VARYING (255),
    password CHARACTER VARYING (255),
    confirmed BOOLEAN DEFAULT false NOT NULL,
    created  TIMESTAMP WITH TIME ZONE DEFAULT now(),
    modified TIMESTAMP WITH TIME ZONE
);

CREATE TRIGGER user_modified BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE update_modification();
