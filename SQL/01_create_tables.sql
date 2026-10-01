CREATE TABLE client (
  client_id int,
  full_name varchar(50),
  birth_date date,
  gender varchar(1),
  region varchar(20),
  registration_date date  
  );
  
create table policy (
  policy_id int,
  client_id int,
  policy_type int,
  start_date date,
  end_date date,
  premium numeric(20,2),
  status int
  );
 
CREATE TABLE payment (
  payment_id int,
  policy_id int,
  payment_date date,
  amount numeric(20,2),
  status int
  );
  
CREATE TABLE claim (
  claim_id int, 
  policy_id int,
  claim_date date,  
  claim_type int,
  claim_amount numeric(20,2),
  status int 
  );
  
create table policy_types (
  type_id int,
  type_name varchar(50)
  );
  
CREATE TABLE policy_statuses (
  status_id int,
  status varchar(10)
  );
   
CREATE TABLE payment_statuses (
  status_id int,
  status varchar(10)
  );
 
CREATE TABLE claim_types (
  type_id int,
  policy_type_id int,
  type_name varchar(50)
  );
  
CREATE TABLE claim_statuses (
  status_id int,
  status varchar(10)
  );
  
