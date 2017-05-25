-- 2 up

CREATE TABLE users (
    id       SERIAL PRIMARY KEY,
    username     CHARACTER VARYING (255) UNIQUE,  
    email    CHARACTER VARYING (255),
    created  TIMESTAMP WITH TIME ZONE DEFAULT now(),
    modified TIMESTAMP WITH TIME ZONE,
    password CHARACTER VARYING (255)
);

CREATE TRIGGER user_modified BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE update_modification();

-- 2 down
DROP TABLE users;