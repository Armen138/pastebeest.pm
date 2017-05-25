-- 4 up

CREATE TABLE profiles (
    id       SERIAL PRIMARY KEY,
    user_id  INTEGER REFERENCES users(id), -- one to one
    avatar    CHARACTER VARYING (255),
    active BOOLEAN DEFAULT true NOT NULL,    
    created  TIMESTAMP WITH TIME ZONE DEFAULT now(),
    modified TIMESTAMP WITH TIME ZONE
);

CREATE TRIGGER profile_modified BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE PROCEDURE update_modification();

-- 4 down
DROP TABLE profiles;