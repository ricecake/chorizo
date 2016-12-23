    CREATE USER chorizo PASSWORD 'EXAMPLE#!';
    CREATE DATABASE chorizo;
    CREATE TYPE timeunit AS ENUM ('minute', 'hour', 'day', 'week', 'month', 'quarter', 'year');
\connect chorizo
BEGIN;
    CREATE EXTENSION "uuid-ossp";
    CREATE EXTENSION "citext";

    CREATE TABLE users (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        username CITEXT NOT NULL,
        email CITEXT NOT NULL,
        uuid CITEXT NOT NULL DEFAULT uuid_generate_v4()
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE users TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE users_id_seq TO chorizo;

    CREATE TABLE workgroup (
        id SERIAL PRIMARY KEY,
        name CITEXT NOT NULL,
        uuid CITEXT NOT NULL DEFAULT uuid_generate_v4()
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE workgroup TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE workgroup_id_seq TO chorizo;

    CREATE TABLE tasks (
        id SERIAL PRIMARY KEY,
        workgroup INTEGER NOT NULL REFERENCES workgroup(id),
        name CITEXT NOT NULL,
        uuid CITEXT NOT NULL DEFAULT uuid_generate_v4()
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE tasks TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE tasks_id_seq TO chorizo;

    CREATE TABLE workgroup_users (
        id SERIAL PRIMARY KEY,
        workgroup INTEGER NOT NULL REFERENCES workgroup(id),
        member INTEGER NOT NULL REFERENCES users(id)
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE workgroup_users TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE workgroup_users_id_seq TO chorizo;

    CREATE TABLE intervals (
        id SERIAL PRIMARY KEY
        quantity INTEGER NOT NULL,
        unit CITEXT NOT NULL
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE intervals TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE intervals_id_seq TO chorizo;

    CREATE TABLE task_intervals (
        id SERIAL PRIMARY KEY,
        interval INTEGER NOT NULL REFERENCES intervals(id),
        task INTEGER NOT NULL REFERENCES tasks(id)
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE task_intervals TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE task_intervals_id_seq TO chorizo;

    CREATE TABLE task_options (
        id SERIAL PRIMARY KEY,
        task INTEGER NOT NULL REFERENCES task(id),
        key TEXT NOT NULL,
        value TEXT NOT NULL
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE task_options TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE task_options_id_seq TO chorizo;

    CREATE TABLE task_occurence (
        id SERIAL PRIMARY KEY,
        task INTEGER NOT NULL REFERENCES task(id),
        uuid CITEXT NOT NULL DEFAULT uuid_generate_v4(),
        generated TIMESTAMP WITH TIMEZONE NOT NULL DEFAULT NOW()
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE task_occurence TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE task_occurence_id_seq TO chorizo;

    CREATE TABLE task_claim (
        id SERIAL PRIMARY KEY,
        task INTEGER NOT NULL REFERENCES task_occurence(id),
        claiment INTEGER NOT NULL REFERENCES users(id),
        claimed TIMESTAMP WITH TIMEZONE NOT NULL DEFAULT NOW()
    );
    GRANT SELECT, UPDATE, INSERT ON TABLE task_claim TO chorizo;
    GRANT USAGE, SELECT ON SEQUENCE task_claim_id_seq TO chorizo;
COMMIT;
