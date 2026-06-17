-- AUTOKEYS SAT V3.3 FULL
-- Ejecutar en Supabase SQL Editor

create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  ot_number text unique,
  date_in text,
  date_out text,
  status text default 'Recibido',
  client_name text,
  client_phone text,
  client_email text,
  vehicle_brand text,
  vehicle_model text,
  vehicle_plate text,
  vehicle_vin text,
  vehicle_year text,
  module_type text,
  module_ref text,
  module_serial text,
  module_source text default 'Aportado por cliente',
  service_type text,
  service_requested text,
  services text,
  fault_description text,
  diagnosis text,
  work_done text,
  replaced_parts text,
  tests_done text,
  client_notes text,
  internal_notes text,
  technician_main text,
  reviewed_by text,
  income_service numeric default 0,
  income_extra numeric default 0,
  expense_parts numeric default 0,
  expense_other numeric default 0,
  payment_method text default 'Pendiente',
  paid boolean default false,
  warranty_applies boolean default true,
  warranty_notes text
);

alter table orders add column if not exists date_in text;
alter table orders add column if not exists date_out text;
alter table orders add column if not exists client_email text;
alter table orders add column if not exists vehicle_vin text;
alter table orders add column if not exists vehicle_year text;
alter table orders add column if not exists module_ref text;
alter table orders add column if not exists module_serial text;
alter table orders add column if not exists module_source text default 'Aportado por cliente';
alter table orders add column if not exists service_type text;
alter table orders add column if not exists service_requested text;
alter table orders add column if not exists services text;
alter table orders add column if not exists fault_description text;
alter table orders add column if not exists diagnosis text;
alter table orders add column if not exists work_done text;
alter table orders add column if not exists replaced_parts text;
alter table orders add column if not exists tests_done text;
alter table orders add column if not exists client_notes text;
alter table orders add column if not exists internal_notes text;
alter table orders add column if not exists reviewed_by text;
alter table orders add column if not exists income_extra numeric default 0;
alter table orders add column if not exists expense_other numeric default 0;
alter table orders add column if not exists payment_method text default 'Pendiente';
alter table orders add column if not exists warranty_applies boolean default true;
alter table orders add column if not exists warranty_notes text;

create table if not exists stock_items (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  category text default 'Módulo',
  item_type text,
  brand text,
  model text,
  reference text,
  serial_number text,
  frequency text,
  transponder text,
  compatibility text,
  status text default 'Disponible',
  quantity integer default 1,
  min_quantity integer default 0,
  purchase_price numeric default 0,
  sale_price numeric default 0,
  location text,
  supplier text,
  notes text
);

create table if not exists distributors (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  name text not null,
  contact_person text,
  phone text,
  email text,
  province text,
  distributor_type text default 'Taller',
  tariff text,
  status text default 'Activo',
  notes text
);

create table if not exists file_services (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  fs_number text unique,
  distributor_name text,
  vehicle_brand text,
  vehicle_model text,
  engine text,
  ecu text,
  hw text,
  sw text,
  tool_read text,
  service_requested text,
  status text default 'Recibido',
  price numeric default 0,
  internal_cost numeric default 0,
  paid boolean default false,
  original_file_name text,
  modified_file_name text,
  notes text
);

alter table orders enable row level security;
alter table stock_items enable row level security;
alter table distributors enable row level security;
alter table file_services enable row level security;

drop policy if exists "orders_all_v33" on orders;
create policy "orders_all_v33" on orders for all using (true) with check (true);
drop policy if exists "stock_all_v33" on stock_items;
create policy "stock_all_v33" on stock_items for all using (true) with check (true);
drop policy if exists "dist_all_v33" on distributors;
create policy "dist_all_v33" on distributors for all using (true) with check (true);
drop policy if exists "fs_all_v33" on file_services;
create policy "fs_all_v33" on file_services for all using (true) with check (true);


-- Campos extra V4.0 garantía profesional
alter table orders add column if not exists client_dni text;
alter table orders add column if not exists warranty_period text default '3 meses sobre la intervención realizada';
alter table orders add column if not exists warranty_type text default 'Servicio técnico';
alter table orders add column if not exists material_condition text default 'Aportado por cliente';
alter table orders add column if not exists customer_signature text;
alter table orders add column if not exists autokeys_signature text;
alter table orders add column if not exists delivery_conditions text;


-- AUTOKEYS SAT V4.1 INTEGRADA
-- Campos para presupuesto, historial, adjuntos manuales y caso técnico dentro de cada OT

alter table orders add column if not exists budget_number text;
alter table orders add column if not exists budget_status text default 'Pendiente';
alter table orders add column if not exists labor_hours numeric default 0;
alter table orders add column if not exists labor_rate numeric default 0;
alter table orders add column if not exists budget_margin numeric default 0;
alter table orders add column if not exists budget_notes text;
alter table orders add column if not exists accepted boolean default false;
alter table orders add column if not exists attachment_notes text;
alter table orders add column if not exists technical_case text;
alter table orders add column if not exists technical_solution text;
alter table orders add column if not exists document_notes text;


-- AUTOKEYS V6 PRESUPUESTOS PREMIUM INDEPENDIENTES
create table if not exists quotations (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  quote_number text unique,
  quote_date text,
  validity text default '30 días',
  status text default 'Pendiente',
  client_name text,
  client_dni text,
  client_phone text,
  client_email text,
  vehicle_plate text,
  vehicle_brand text,
  vehicle_model text,
  vehicle_vin text,
  lines jsonb default '[]'::jsonb,
  notes text,
  subtotal numeric default 0,
  tax_percent numeric default 21,
  tax_amount numeric default 0,
  total_amount numeric default 0
);
alter table quotations enable row level security;
drop policy if exists "quotations_all_v6" on quotations;
create policy "quotations_all_v6" on quotations for all using (true) with check (true);


-- AUTOKEYS V6.1 LINEAS DE FACTURA / TICKET / ALBARAN
alter table orders add column if not exists invoice_lines jsonb default '[]'::jsonb;
alter table invoices add column if not exists lines jsonb default '[]'::jsonb;
