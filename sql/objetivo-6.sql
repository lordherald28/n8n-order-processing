-- Migración del objetivo 6. Aplicar una sola vez al preparar el entorno.
-- Los pedidos anteriores conservan valores desconocidos (NULL).
BEGIN;

ALTER TABLE public.pedidos
  ADD COLUMN idempotency_key text,
  ADD COLUMN recepcion_id text,
  ADD COLUMN solicitud_original jsonb,
  ADD COLUMN aprobacion_intentada boolean;

-- Los pedidos anteriores mantienen NULL. El workflow asigna una clave
-- interna distinta a cada recepción sin cabecera.
-- La restricción resuelve carreras entre solicitudes con la misma clave.
CREATE UNIQUE INDEX pedidos_idempotency_key_objetivo_6_uidx
  ON public.pedidos (idempotency_key)
  WHERE idempotency_key IS NOT NULL;

-- La recepción identifica reintentos internos incluso sin cabecera.
CREATE UNIQUE INDEX pedidos_recepcion_objetivo_6_uidx
  ON public.pedidos (recepcion_id)
  WHERE recepcion_id IS NOT NULL;

COMMIT;
