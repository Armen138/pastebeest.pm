-- 1 up

SET client_encoding = 'UTF8';

DO $$
  BEGIN
    CREATE PROCEDURAL LANGUAGE plpgsql;
  EXCEPTION
    WHEN others THEN RAISE NOTICE 'language available';
  END;
$$;

CREATE OR REPLACE FUNCTION update_modification() RETURNS trigger AS $$
BEGIN
  NEW.modified := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
