-- Insert  user_role
INSERT INTO user_role (name) VALUES
('admin'),
('user'),
('moderator');

-- Insert  plan
INSERT INTO plan (name, price, description) VALUES
('Basic', 9.99, 'Basic plan with limited features'),
('Premium', 19.99, 'Premium plan with full features'),
('Pro', 29.99, 'Pro plan with advanced features');

-- Insert  app_user
INSERT INTO app_user (username, password, email, birth_date, level, points, coins, picture_url, fk_plan_id, fk_user_role_id, name) VALUES--
('user1', 'ab', 'user1@example.com', '1990-01-01', 1, 100, 50, 'http://example.com/user1.jpg', 1, 2, 'John Doe')	
('user2', 'password2', 'user2@example.com', '1985-05-15', 2, 200, 100, 'http://example.com/user2.jpg', 2, 2, 'Jane Smith'),
('admin', 'adminpassword', 'admin@example.com', '1980-03-30', 5, 1000, 500, 'http://example.com/admin.jpg', 3, 1, 'Alice Admin');

-- Insert  streak
INSERT INTO streak (initial_date, final_date, fk_app_user_id) VALUES
('2024-08-01', '2024-08-07', 1),
('2024-08-01', NULL, 2);


-- Insert  theme
INSERT INTO theme (name, price, store_picture_url) VALUES--
('Dark Mode', 100, 'http://example.com/dark_mode.jpg'),
('Light Mode', 100, 'http://example.com/light_mode.jpg');

-- Insert  powerup
INSERT INTO powerup (name, price, store_picture_url) VALUES--
('Double Points', 50, 'http://example.com/double_points.jpg'),
('Extra Life', 75, 'http://example.com/extra_life.jpg');

-- Insert  app_user_theme
INSERT INTO app_user_theme (fk_theme_id, fk_app_user_id, is_in_use) VALUES
(1, 1, true),
(2, 2, false);
-- Insert  app_user_powerup
INSERT INTO app_user_powerup (fk_app_user_id, fk_powerup_id) VALUES
(1, 1),
(2, 2);	

-- Insert  plan_payment
INSERT INTO plan_payment (price, expiration_timestamp, fk_plan_id, fk_app_user_id) VALUES
(9.99, '2024-12-31 23:59:59', 1, 1),
(19.99, '2024-12-31 23:59:59', 2, 2);


CREATE TABLE app_user ( 
	username varchar(20) NOT NULL,
    password text NOT NULL,
    email varchar(100) NOT NULL,
    birth_date date NOT NULL,
    level integer DEFAULT 1 NOT NULL CHECK(level >= 1),
    points integer DEFAULT 0 NOT NULL CHECK(points >= 0),
    coins integer DEFAULT 0 NOT NULL CHECK(coins >= 0),
    picture_url text,
    id serial PRIMARY KEY NOT NULL,
    fk_plan_id integer NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP, -- Esta variável interage com o aplicativo, quando houver uma mudança no perfil no aplicativo, ocorrerá uma mudança nesse campo
    fk_user_role_id integer NOT NULL, 
    name varchar(150) NOT NULL,
    UNIQUE (username, email)
);

CREATE TABLE streak ( --Feito
    id serial PRIMARY KEY NOT NULL,
    initial_date date NOT NULL, 
    final_date date, -- procedure para isso
    fk_app_user_id integer NOT NULL
);

CREATE TABLE theme ( --Feito
    name varchar(30) NOT NULL,
    price integer NOT NULL CHECK(price >= 0),
    store_picture_url text NOT NULL,
    id serial PRIMARY KEY NOT NULL,
    UNIQUE (name, store_picture_url)
);

CREATE TABLE plan ( --Feito
    name varchar(20) NOT NULL,
    price numeric(10, 2) NOT NULL CHECK(price >= 0),
    description varchar(500) NOT NULL,
    id serial PRIMARY KEY NOT NULL,
    UNIQUE (name, description)
);


CREATE TABLE powerup ( --Feito
    name varchar(30) NOT NULL,
    price integer NOT NULL CHECK(price >= 0),
    store_picture_url text NOT NULL,
    id serial PRIMARY KEY NOT NULL,
    UNIQUE (name, store_picture_url)
);

CREATE TABLE app_user_theme ( --Feito
    fk_theme_id integer NOT NULL,
    fk_app_user_id integer NOT NULL,
    is_in_use boolean NOT NULL,
    id serial PRIMARY KEY NOT NULL
);

CREATE TABLE app_user_powerup ( --Feito
    fk_app_user_id integer NOT NULL,
    fk_powerup_id integer NOT NULL,
    id serial PRIMARY KEY NOT NULL
);

CREATE TABLE plan_payment (  --Feito
    id serial PRIMARY KEY NOT NULL,
    price numeric(10, 2) NOT NULL CHECK(price > 0),
    payment_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,--trigger/procedurefunction
    expiration_timestamp timestamp NOT NULL,--trigger/procedurefunction
    fk_plan_id integer NOT NULL,
    fk_app_user_id integer NOT NULL
);

CREATE TABLE user_role (--Feito
    id serial PRIMARY KEY,
    name varchar(20) NOT NULL,
    UNIQUE(name)
);



-- Criando a tabela log para operações nas tabelas 
CREATE TABLE theme_log (
    name varchar(30) NOT NULL,
    price integer NOT NULL CHECK(price >= 0),
    store_picture_url text NOT NULL,
    id serial PRIMARY KEY NOT NULL,
    UNIQUE (name, store_picture_url),
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);



CREATE TABLE plan_log (
    name varchar(20) NOT NULL,
    price numeric(10, 2) NOT NULL CHECK(price >= 0),
    description varchar(500) NOT NULL,
    id serial PRIMARY KEY NOT NULL,
    UNIQUE (name, description),
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);

CREATE TABLE powerup_log (
    name varchar(30) NOT NULL,
    price integer NOT NULL CHECK(price >= 0),
    store_picture_url text NOT NULL,
    id serial PRIMARY KEY NOT NULL,
    UNIQUE (name, store_picture_url),
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);

CREATE TABLE app_user_theme_log (  
    fk_theme_id integer NOT NULL,
    fk_app_user_id integer NOT NULL,
    is_in_use boolean NOT NULL,
    id serial PRIMARY KEY NOT NULL,
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);

CREATE TABLE app_user_powerup_LOG ( 
    fk_app_user_id integer NOT NULL,
    fk_powerup_id integer NOT NULL,
    id serial PRIMARY KEY NOT NULL,
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);



CREATE TABLE streak_log (                     
    id serial PRIMARY KEY NOT NULL,
    initial_date date NOT NULL, 
    final_date date,--trigger that calls a procedure
    fk_app_user_id integer NOT NULL,
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);


CREATE TABLE plan_payment_log ( 
    id serial PRIMARY KEY NOT NULL,
    price numeric(10, 2) NOT NULL CHECK(price > 0),
    payment_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expiration_timestamp timestamp NOT NULL,--trigger que chama a procedure 
    fk_plan_id integer NOT NULL,
    fk_app_user_id integer NOT NULL,
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);


CREATE TABLE user_role_log ( 
    id serial PRIMARY KEY,
    name varchar(20) NOT NULL,
    UNIQUE(name),
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);

CREATE TABLE app_user_log (
	username varchar(20) NOT NULL,
    password text NOT NULL,
    email varchar(100) NOT NULL,
    birth_date date NOT NULL,
    level integer DEFAULT 1 NOT NULL CHECK(level >= 1),
    points integer DEFAULT 0 NOT NULL CHECK(points >= 0),
    coins integer DEFAULT 0 NOT NULL CHECK(coins >= 0),
    picture_url text,
    id serial PRIMARY KEY NOT NULL,
    fk_plan_id integer NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP, -- Esta variável interage com o aplicativo, quando houver uma mudança no perfil no aplicativo, ocorrerá uma mudança nesse campo
    fk_user_role_id integer NOT NULL, 
    name varchar(150) NOT NULL,
    UNIQUE (username, email),
	Operation VARCHAR(10),
    UpdatedOn TIMESTAMP,
    UpdatedBy VARCHAR(50)
);



-- Criar a trigger function para o logging das operações
CREATE OR REPLACE FUNCTION log_theme_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
			INSERT INTO theme_log (name,price,store_picture_url,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (OLD.name, OLD.price, OLD.store_picture_url, OLD.id, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO theme_log (name,price,store_picture_url,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (NEW.name, NEW.price, NEW.store_picture_url, NEW.id, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
         INSERT INTO theme_log (name,price,store_picture_url,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (NEW.name, NEW.price, NEW.store_picture_url, NEW.id, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Criando triggers para a tabela
CREATE TRIGGER theme_insert_trigger
AFTER INSERT ON theme
FOR EACH ROW EXECUTE FUNCTION log_theme_changes();

CREATE TRIGGER theme_update_trigger
AFTER UPDATE ON theme
FOR EACH ROW EXECUTE FUNCTION log_theme_changes();

CREATE TRIGGER theme_delete_trigger
AFTER DELETE ON theme
FOR EACH ROW EXECUTE FUNCTION log_theme_changes();


--------------------------


CREATE OR REPLACE FUNCTION log_plan_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
			INSERT INTO plan_log (name,price,description,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (OLD.name, OLD.price, OLD.description, OLD.id, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO plan_log (name,price,description,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (NEW.name, NEW.price, NEW.description, NEW.id, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
         INSERT INTO plan_log (name,price,description,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (NEW.name, NEW.price, NEW.description, NEW.id, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER plan_insert_trigger
AFTER INSERT ON plan
FOR EACH ROW EXECUTE FUNCTION log_plan_changes();

CREATE TRIGGER plan_update_trigger
AFTER UPDATE ON plan
FOR EACH ROW EXECUTE FUNCTION log_plan_changes();

CREATE TRIGGER plan_delete_trigger
AFTER DELETE ON plan
FOR EACH ROW EXECUTE FUNCTION log_plan_changes();





CREATE OR REPLACE FUNCTION powerup_log_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
			INSERT INTO powerup_log (name,price,store_picture_url,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (OLD.name, OLD.price, OLD.store_picture_url, OLD.id, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO powerup_log (name,price,store_picture_url,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (NEW.name, NEW.price, NEW.store_picture_url, NEW.id, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
         INSERT INTO powerup_log (name,price,store_picture_url,id, Operation, UpdatedOn, UpdatedBy )
        VALUES (NEW.name, NEW.price, NEW.store_picture_url, NEW.id, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER powerup_insert_trigger
AFTER INSERT ON powerup
FOR EACH ROW EXECUTE FUNCTION powerup_log_changes();

CREATE TRIGGER powerup_update_trigger
AFTER UPDATE ON powerup
FOR EACH ROW EXECUTE FUNCTION powerup_log_changes();

CREATE TRIGGER powerup_delete_trigger
AFTER DELETE ON powerup
FOR EACH ROW EXECUTE FUNCTION powerup_log_changes();




CREATE OR REPLACE FUNCTION app_user_theme_log_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
			INSERT INTO app_user_theme_log (fk_theme_id,fk_app_user_id,is_in_use,id,Operation,UpdatedOn,UpdatedBy)
        VALUES (OLD.fk_theme_id, OLD.fk_app_user_id, OLD.is_in_use, OLD.id, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO app_user_theme_log (fk_theme_id,fk_app_user_id,is_in_use,id,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.fk_theme_id, NEW.fk_app_user_id, NEW.is_in_use, NEW.id, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
         INSERT INTO app_user_theme_log (fk_theme_id,fk_app_user_id,is_in_use,id,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.fk_theme_id, NEW.fk_app_user_id, NEW.is_in_use, NEW.id, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER app_user_theme_insert_trigger
AFTER INSERT ON app_user_theme
FOR EACH ROW EXECUTE FUNCTION app_user_theme_log_changes();

CREATE TRIGGER app_user_theme_update_trigger
AFTER UPDATE ON app_user_theme
FOR EACH ROW EXECUTE FUNCTION app_user_theme_log_changes();

CREATE TRIGGER app_user_theme_delete_trigger
AFTER DELETE ON app_user_theme
FOR EACH ROW EXECUTE FUNCTION app_user_theme_log_changes();


CREATE OR REPLACE FUNCTION app_user_powerup_log_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
			INSERT INTO app_user_powerup_log (fk_app_user_id,fk_powerup_id,id,Operation,UpdatedOn,UpdatedBy)
        VALUES (OLD.fk_app_user_id, OLD.fk_powerup_id, OLD.id, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO app_user_powerup_log (fk_app_user_id,fk_powerup_id,id,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.fk_app_user_id, NEW.fk_powerup_id, NEW.id, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
         INSERT INTO app_user_powerup_log (fk_app_user_id,fk_powerup_id,id,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.fk_app_user_id, NEW.fk_powerup_id, NEW.id, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;





CREATE TRIGGER app_user_powerup_insert_trigger
AFTER INSERT ON app_user_powerup
FOR EACH ROW EXECUTE FUNCTION app_user_powerup_log_changes();

CREATE TRIGGER app_user_powerup_update_trigger
AFTER UPDATE ON app_user_powerup
FOR EACH ROW EXECUTE FUNCTION app_user_powerup_log_changes();

CREATE TRIGGER app_user_powerup_delete_trigger
AFTER DELETE ON app_user_powerup
FOR EACH ROW EXECUTE FUNCTION app_user_powerup_log_changes();










CREATE OR REPLACE FUNCTION streak_log_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
		INSERT INTO streak_log (id,initial_date,final_date,fk_app_user_id,Operation,UpdatedOn,UpdatedBy)
        VALUES (OLD.id, OLD.initial_date, OLD.final_date,OLD.fk_app_user_id, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO streak_log (id,initial_date,final_date,fk_app_user_id,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.id, NEW.initial_date, NEW.final_date,NEW.fk_app_user_id, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
         INSERT INTO streak_log (id,initial_date,final_date,fk_app_user_id,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.id, NEW.initial_date, NEW.final_date,NEW.fk_app_user_id, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;





CREATE TRIGGER streak_insert_trigger
AFTER INSERT ON streak
FOR EACH ROW EXECUTE FUNCTION streak_log_changes();

CREATE TRIGGER streak_update_trigger
AFTER UPDATE ON streak
FOR EACH ROW EXECUTE FUNCTION streak_log_changes();

CREATE TRIGGER streak_delete_trigger
AFTER DELETE ON streak
FOR EACH ROW EXECUTE FUNCTION streak_log_changes();







CREATE OR REPLACE FUNCTION plan_payment_log_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
		INSERT INTO plan_payment_log (id,price,payment_timestamp,expiration_timestamp,fk_plan_id,fk_app_user_id,Operation,UpdatedOn,UpdatedBy)
        VALUES (OLD.id, OLD.price, OLD.payment_timestamp,OLD.expiration_timestamp,OLD.fk_plan_id,OLD.fk_app_user_id, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO plan_payment_log (id,price,payment_timestamp,expiration_timestamp,fk_plan_id,fk_app_user_id,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.id, NEW.price, NEW.payment_timestamp,NEW.expiration_timestamp,NEW.fk_plan_id,NEW.fk_app_user_id, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
         INSERT INTO plan_payment_log (id,price,payment_timestamp,expiration_timestamp,fk_plan_id,fk_app_user_id,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.id, NEW.price, NEW.payment_timestamp,NEW.expiration_timestamp,NEW.fk_plan_id,NEW.fk_app_user_id, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;





CREATE TRIGGER plan_payment_insert_trigger
AFTER INSERT ON plan_payment
FOR EACH ROW EXECUTE FUNCTION plan_payment_log_changes();

CREATE TRIGGER plan_payment_update_trigger
AFTER UPDATE ON plan_payment
FOR EACH ROW EXECUTE FUNCTION plan_payment_log_changes();

CREATE TRIGGER plan_payment_delete_trigger
AFTER DELETE ON plan_payment
FOR EACH ROW EXECUTE FUNCTION plan_payment_log_changes();











CREATE OR REPLACE FUNCTION user_role_log_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
		INSERT INTO user_role_log (id,name,Operation,UpdatedOn,UpdatedBy)
        VALUES (OLD.id, OLD.name, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO user_role_log (id,name,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.id, NEW.name, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
         INSERT INTO user_role_log(id,name,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.id, NEW.name, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;





CREATE TRIGGER user_role_insert_trigger
AFTER INSERT ON user_role
FOR EACH ROW EXECUTE FUNCTION user_role_log_changes();

CREATE TRIGGER user_role_update_trigger
AFTER UPDATE ON user_role
FOR EACH ROW EXECUTE FUNCTION user_role_log_changes();

CREATE TRIGGER user_role_delete_trigger
AFTER DELETE ON user_role
FOR EACH ROW EXECUTE FUNCTION user_role_log_changes();



CREATE OR REPLACE FUNCTION app_user_log_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
		INSERT INTO user_role_log ( username,password,email,birth_date,level,points,coins,picture_url,id,fk_plan_id,created_at,updated_at,fk_user_role_id,name,Operation,UpdatedOn,UpdatedBy)
        VALUES (OLD.username, OLD.password, OLD.email, OLD.birth_date, OLD.level, OLD.points, OLD.coins, OLD.picture_url, OLD.id, OLD.fk_plan_id,OLD.created_at,OLD.updated_at,OLD.fk_user_role_id, 'DELETE', NOW(), current_user);
    ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO user_role_log ( username,password,email,birth_date,level,points,coins,picture_url,id,fk_plan_id,created_at,updated_at,fk_user_role_id,name,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.username, NEW.password, NEW.email, NEW.birth_date, NEW.level, NEW.points, NEW.coins, NEW.picture_url, NEW.id, NEW.fk_plan_id,NEW.created_at,NEW.updated_at,NEW.fk_user_role_id, 'UPDATE', NOW(), current_user);
    ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO user_role_log ( username,password,email,birth_date,level,points,coins,picture_url,id,fk_plan_id,created_at,updated_at,fk_user_role_id,name,Operation,UpdatedOn,UpdatedBy)
        VALUES (NEW.username, NEW.password, NEW.email, NEW.birth_date, NEW.level, NEW.points, NEW.coins, NEW.picture_url, NEW.id, NEW.fk_plan_id,NEW.created_at,NEW.updated_at,NEW.fk_user_role_id, 'INSERT', NOW(), current_user);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;





CREATE TRIGGER app_user_insert_trigger
AFTER INSERT ON app_user
FOR EACH ROW EXECUTE FUNCTION app_user_log_changes();

CREATE TRIGGER app_user_update_trigger
AFTER UPDATE ON app_user
FOR EACH ROW EXECUTE FUNCTION app_user_log_changes();

CREATE TRIGGER app_user_delete_trigger
AFTER DELETE ON app_user
FOR EACH ROW EXECUTE FUNCTION app_user_log_changes();












-- Criar uma function para validação de formato de email para a tabela app_user
-- Criar uma função para outros fin
CREATE OR REPLACE FUNCTION validate_email()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email !~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' THEN
        RAISE EXCEPTION 'Invalid email format';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar a trigger para validação de email (na inserção) no app_user table
	CREATE TRIGGER app_user_email_validation_trigger
BEFORE INSERT OR UPDATE ON app_user
FOR EACH ROW EXECUTE FUNCTION validate_email();















CREATE TRIGGER theme_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON theme
FOR EACH ROW EXECUTE FUNCTION log_table_changes();


CREATE TRIGGER streak_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON streak
FOR EACH ROW EXECUTE FUNCTION log_table_changes();

CREATE TRIGGER theme_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON theme
FOR EACH ROW EXECUTE FUNCTION log_table_changes();

CREATE TRIGGER plan_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON plan
FOR EACH ROW EXECUTE FUNCTION log_table_changes();

CREATE TRIGGER powerup_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON powerup
FOR EACH ROW EXECUTE FUNCTION log_table_changes();

CREATE TRIGGER app_user_theme_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON app_user_theme
FOR EACH ROW EXECUTE FUNCTION log_table_changes();

CREATE TRIGGER app_user_powerup_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON app_user_powerup
FOR EACH ROW EXECUTE FUNCTION log_table_changes();

CREATE TRIGGER plan_payment_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON plan_payment
FOR EACH ROW EXECUTE FUNCTION log_table_changes();

CREATE TRIGGER user_role_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON user_role
FOR EACH ROW EXECUTE FUNCTION log_table_changes();
	
	
	


--Teste a encriptação com o Insert Abaixo

--INSERT INTO app_user (username, password, email, birth_date, level, points, coins, picture_url, fk_plan_id, fk_user_role_id, name) VALUES--
--('user22', 'AB', 'user1@example.com', '1990-01-01', 1, 100, 50, 'http://example.com/user1.jpg', 1, 1, 'Jon Einrich');



-- Cria a procedure de encriptação de senha do usuário
CREATE OR REPLACE PROCEDURE encrypt_password_proc(INOUT p TEXT) LANGUAGE plpgsql AS $$
DECLARE
    -- Arrays para os mapeamos dos caracteres alfabeticos
    lower_case_alphabet TEXT[] := '{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
    upper_case_alphabet TEXT[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}';
    char TEXT;
    next_char TEXT;
    index INT;
    result TEXT := '';
BEGIN
    -- Loop through each character of the password
    FOR i IN 1..length(p) LOOP
        char := substring(p FROM i FOR 1);
        
        -- Processa as letras lowercase 
        IF char = ANY(lower_case_alphabet) THEN
            index := array_position(lower_case_alphabet, char);
            next_char := lower_case_alphabet[(index % 26) + 1];
            result := result || next_char;
        
        -- Processa as letras uppercase
        ELSIF char = ANY(upper_case_alphabet) THEN
            index := array_position(upper_case_alphabet, char);
            next_char := upper_case_alphabet[(index % 26) + 1];
            result := result || next_char;
        
        ELSE
            -- Se não uma letra, só faz o append do  caracterere do jeito que vir
            result := result || char;
        END IF;
    END LOOP;
	COMMIT
    
    -- Seta o resultado como a password nova
    p := result;
END;
$$;
-- Criar a trigger function que chama a procedure
CREATE OR REPLACE FUNCTION trigger_encrypt_password() RETURNS TRIGGER AS $$
BEGIN
    -- Call the procedure to encrypt the password
    CALL encrypt_password_proc(NEW.Password);
    -- Seta a password encripitada para ser a NEW/nova password
    NEW.Password := NEW.Password;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar ou substituir o trigger
CREATE OR REPLACE TRIGGER before_insert_encrypt
BEFORE INSERT ON app_user
FOR EACH ROW
EXECUTE FUNCTION trigger_encrypt_password();



CREATE OR REPLACE PROCEDURE update_final_date_streak(p_id integer, p_initial_date date)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Transação manuseando uma procedure (internamente)
    BEGIN
        -- Update na streak_log
        UPDATE streak
        SET final_date = p_initial_date + INTERVAL '7 days'
        WHERE id = p_id;
		COMMIT
    EXCEPTION
        WHEN OTHERS THEN
            -- Manuseia exceptions
            RAISE NOTICE 'Exception: %', SQLERRM;
            -- ROLLBACK; -- Não tipicamente necessário para o contexto de trigger
    END;
END;
$$;

CREATE OR REPLACE FUNCTION trigger_update_final_date_streak()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Chama a procedure com a identificação do registro de agora e a data inicial do streak 
    CALL update_final_date_streak(NEW.id, NEW.initial_date);
    -- Retorna o novo row (necessário para o AFTER INSERT trigger)
    RETURN NEW;
END;
$$;


CREATE TRIGGER after_insert_streak
AFTER INSERT ON streak
FOR EACH ROW
EXECUTE FUNCTION trigger_update_final_date_streak_log();











CREATE OR REPLACE PROCEDURE update_expiration_timestamp(p_id integer, p_payment_timestamp timestamp)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Transação manuseando uma procedure (internamente)
    BEGIN
        -- Update na plan_payment_log
        UPDATE plan_payment
        SET expiration_timestamp = p_payment_timestamp + INTERVAL '30 days'
        WHERE id = p_id;
		COMMIT
    EXCEPTION
        WHEN OTHERS THEN
            -- Manuseia exceptions
            RAISE NOTICE 'Exceção: %', SQLERRM;
            -- ROLLBACK; -- Não tipicamente necessário para o contexto de trigger
    END;
END;
$$;

CREATE OR REPLACE FUNCTION trigger_update_expiration_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Chama a procedure com a identificação do registro de agora e o payment_timestamp 
    CALL update_expiration_timestamp(NEW.id, NEW.payment_timestamp);
    
    -- Retorna o novo row (necessário para o AFTER INSERT trigger)
    RETURN NEW;
END;
$$;

CREATE TRIGGER after_insert_plan_payment
AFTER INSERT ON plan_payment
FOR EACH ROW
EXECUTE FUNCTION trigger_update_expiration_timestamp();




