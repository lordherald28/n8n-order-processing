-- Los pedidos anteriores al objetivo no tienen un estado conocido.
ALTER TABLE public.pedidos
  ADD COLUMN estado text,
  ADD CONSTRAINT pedidos_estado_objetivo_5_check
    CHECK (estado IN ('PROCESSED', 'PENDING_APPROVAL', 'APPROVED', 'REJECTED'));
