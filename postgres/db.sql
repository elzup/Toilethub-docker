
CREATE TABLE users (
    id SERIAL NOT NULL PRIMARY KEY,
    is_man BOOLEAN NOT NULL,
    age INT NOT NULL,
    has_child BOOLEAN NOT NULL
);

CREATE TABLE toilets (
    id SERIAL NOT NULL PRIMARY KEY,
    name CHAR(40) NOT NULL UNIQUE,
    type INT2 NOT NULL,
    position GEOMETRY(POINT, 4612)
);

CREATE TABLE reviews (
    id SERIAL NOT NULL PRIMARY KEY,
    user_id INT REFERENCES users (id),
    toilet_id INT REFERENCES toilets (id),
    rate INT2 CHECK (rate > 0 AND rate < 6),
    comment TEXT
);

CREATE TABLE options (
    toilet_id INT REFERENCES toilets (id),
    name CHAR(40),
    description TEXT
);
