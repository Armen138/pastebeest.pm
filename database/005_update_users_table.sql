-- 5 up

DO $$
  BEGIN
ALTER TABLE users ADD COLUMN confirmed boolean DEFAULT false NOT NULL;
  EXCEPTION
    WHEN others THEN RAISE NOTICE 'Skipping confirmed user column';
  END;
$$;
 
