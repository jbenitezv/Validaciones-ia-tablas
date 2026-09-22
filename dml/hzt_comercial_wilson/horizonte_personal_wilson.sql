/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_PERSONAL
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_comercial.horizonte_personal`
WHERE des_origen = 'DE-WILSON';

INSERT INTO `{horizonte_project_id}.hzt_comercial.horizonte_personal`

WITH 
-- organizacion_venta AS ( 
--   SELECT
--     SUBSTRING(id_interlocutor,11,10) AS cod_interlocutor,
--     STRING_AGG(DISTINCT cod_organizacion_venta, ',') AS cod_organizacion_venta 
--   FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_cliente_organizacion_venta`
--   WHERE cod_organizacion_venta IN ('1011','1012')
--   GROUP BY cod_interlocutor
-- ),

-- cliente_organizacion_venta AS (
--   SELECT
--     cli.cod_cliente,
--     dov.cod_organizacion_venta,
--     dov.cod_grupo_precio,
--     dov.des_grupo_precio
--   FROM `{golden_project_id}.gld_cliente.s4_cliente` cli
--   CROSS JOIN UNNEST(cli.det_organizacion_venta) AS dov
--   WHERE dov.cod_organizacion_venta IN ('1011','1012')
--   QUALIFY ROW_NUMBER() OVER (
--     PARTITION BY cli.cod_cliente, dov.cod_organizacion_venta
--     ORDER BY 
--       dov.cod_canal_distribucion,
--       dov.cod_sector_comercial,
--       dov.cod_grupo_precio
--   ) = 1
-- ),

s4_personal AS (
  SELECT 
    ROW_NUMBER() OVER(ORDER BY a.id_interlocutor_origen) AS val_rownum,
    SAFE_CAST(NULL AS STRING) AS cod_sociedad, -- TODO: obtener de slv_modelo_interlocutor.horizonte_cliente_organizacion_venta
    a.cod_grupo_interlocutor,
    a.des_grupo_interlocutor,
    SAFE_CAST(NULL AS STRING) AS cod_gerencia_regional,
    SAFE_CAST(NULL AS STRING) AS cod_gerencia_zona,
    -- CASE 
    --   WHEN e.cod_organizacion_venta = '1011' THEN 'CM'
    --   WHEN e.cod_organizacion_venta = '1012' THEN 'AS'
    --   WHEN e.cod_organizacion_venta LIKE '%1011%' THEN 'AMBOS'
    -- END AS des_negocio,
    SAFE_CAST(NULL AS STRING) AS des_negocio,
    -- e.cod_organizacion_venta AS cod_organizacion_venta,
    SAFE_CAST(NULL AS STRING) AS cod_organizacion_venta,
    a.id_interlocutor_origen AS cod_territorio,
    a.id_interlocutor_origen AS cod_personal,
    a.nom_interlocutor AS nom_personal,
    b.tip_documento,
    b.des_numero_documento AS val_documento,
    SAFE_CAST(NULL AS STRING) AS cod_grupo_precio_alicorp, -- dov.cod_grupo_precio,
    SAFE_CAST(NULL AS STRING) AS des_grupo_precio_alicorp, -- dov.des_grupo_precio,
    LEFT(c.num_telefono,3) AS val_prefijo, 
    SUBSTR(c.num_telefono,4) AS val_telefono,
    d.des_email AS val_correo,        
    SAFE_CAST(NULL AS DATE) AS fec_nacimiento,
    a.id_interlocutor_origen AS val_dbkey,
    CURRENT_DATETIME('America/Lima') AS fec_proceso
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor` a
  LEFT JOIN `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_documento` b 
    ON a.id_interlocutor = b.id_interlocutor
  LEFT JOIN `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_telefono` c 
    ON a.id_interlocutor = c.id_interlocutor
  LEFT JOIN `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_email` d 
    ON a.id_interlocutor = d.id_interlocutor 
  -- LEFT JOIN organizacion_venta e 
  --   ON a.id_interlocutor_origen = e.cod_interlocutor

--  LEFT JOIN cliente_organizacion_venta dov
--    ON a.id_interlocutor_origen = dov.cod_cliente
--    AND (
--      (
--        e.cod_organizacion_venta = '1011'
--        AND dov.cod_organizacion_venta = '1011'
--      )
--      OR
--      (
--        e.cod_organizacion_venta = '1012'
--        AND dov.cod_organizacion_venta = '1012'
--      )
--      OR
--      (
--        e.cod_organizacion_venta LIKE '%1011%'
--        AND e.cod_organizacion_venta LIKE '%1012%'
--        AND dov.cod_organizacion_venta = '1011'
--      )
--    )

  --WHERE a.cod_grupo_interlocutor IN ('ZTER','ZC') 
)

SELECT
  'DE-WILSON' AS des_origen,
   val_rownum,
   cod_sociedad,
   cod_grupo_interlocutor,
   des_grupo_interlocutor,
   cod_gerencia_regional,
   cod_gerencia_zona,
   des_negocio,
   cod_organizacion_venta,
   cod_territorio,
   cod_personal,
   nom_personal,
   tip_documento,
   val_documento,
   cod_grupo_precio_alicorp,
   des_grupo_precio_alicorp,
   val_prefijo,
   val_telefono,
   val_correo,
   fec_nacimiento,
   val_dbkey,
   fec_proceso
FROM s4_personal;