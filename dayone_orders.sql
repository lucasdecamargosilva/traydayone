-- Tabela de pedidos da Day One Store (Tray, loja 926316)
-- Schema espelha mariana_vendas_provador — os nomes das colunas TÊM que bater
-- com a config em `lojistas` (campo_data_pedido, campo_total_pedido, etc.),
-- senão o dashboard do lojista não acha os dados.
-- Rodar no SQL Editor do Supabase (DDL não passa por PostgREST nem por n8n→Postgres).

create table if not exists public.dayone_orders (
  id                 uuid primary key default gen_random_uuid(),
  id_pedido          text unique,
  data_pedido        timestamptz,
  valor_pedido       numeric,
  status_pedido      text,
  cliente_nome       text,
  cliente_email      text,
  cliente_telefone   text,
  produto_provado    text,
  telefone_provador  text,
  data_provador      date,
  created_at         timestamptz default now()
);

-- O dashboard pagina por data e cruza por telefone; sem estes índices
-- a loja fica lenta assim que o volume subir.
create index if not exists dayone_orders_data_pedido_idx on public.dayone_orders (data_pedido);
create index if not exists dayone_orders_telefone_idx    on public.dayone_orders (cliente_telefone);
create index if not exists dayone_orders_status_idx      on public.dayone_orders (status_pedido);

alter table public.dayone_orders enable row level security;

drop policy if exists "dayone_orders_select" on public.dayone_orders;
create policy "dayone_orders_select" on public.dayone_orders
  for select using (true);
