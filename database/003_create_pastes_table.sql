-- 3 down
DROP TABLE IF EXISTS pastes;

-- 3 up

CREATE TABLE pastes (
    id       SERIAL PRIMARY KEY,
    deleted  BOOLEAN DEFAULT false NOT NULL,
    user_id  INTEGER REFERENCES users(id), -- creator
    slug     CHARACTER VARYING (255) UNIQUE,   -- used to build url
    title    CHARACTER VARYING (255),    -- title
    lang     CHARACTER VARYING (255),   -- perl?
    created  TIMESTAMP WITH TIME ZONE DEFAULT now(),
    modified TIMESTAMP WITH TIME ZONE,
    body    TEXT
);

CREATE TRIGGER paste_modified BEFORE UPDATE ON pastes FOR EACH ROW EXECUTE PROCEDURE update_modification();
