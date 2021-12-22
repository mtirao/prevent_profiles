-- This file is created by the IHP Schema Designer.
-- When you generate a new migration, all changes in this file will be copied into your migration.
--
-- Use http://localhost:8001/NewMigration or `new-migration` to generate a new migration.
--
-- Learn more about migrations: https://ihp.digitallyinduced.com/Guide/database-migrations.html
CREATE TABLE profiles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    user_role TEXT NOT NULL,
    user_name TEXT NOT NULL,
    user_password TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    cell_phone TEXT NOT NULL
);
CREATE TABLE doctors (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    realm TEXT NOT NULL,
    license_number TEXT NOT NULL,
    profile UUID NOT NULL
);
CREATE TABLE patients (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    insurance_type TEXT NOT NULL,
    preferred_contact_method TEXT NOT NULL,
    profile UUID NOT NULL,
    national_id TEXT NOT NULL,
    " birthday" DATE NOT NULL
);
