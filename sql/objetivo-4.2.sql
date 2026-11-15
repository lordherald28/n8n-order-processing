CREATE TABLE public.pedidos (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cliente text NOT NULL,
  email text NOT NULL,
  total numeric NOT NULL
);
CREATE TABLE public.productos (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pedido_id bigint NOT NULL REFERENCES public.pedidos(id),
  nombre text NOT NULL,
  cantidad numeric NOT NULL,
  precio numeric NOT NULL
);
