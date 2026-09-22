/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_INTERLOCUTOR_COMERCIAL_SOCIEDAD

  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_finanzas.horizonte_interlocutor_comercial_sociedad`
WHERE des_origen = 'DE-WILSON';

INSERT INTO `{horizonte_project_id}.hzt_finanzas.horizonte_interlocutor_comercial_sociedad`
WITH
datos_interlcutor AS (
  SELECT 
    id_interlocutor, 
    id_interlocutor_origen, 
    cod_tipo_interlocutor_especial, 
    cod_grupo_interlocutor, 
    CASE
      WHEN cod_grupo_interlocutor = 'ZINT' THEN 'Intercompany' 
      WHEN cod_grupo_interlocutor = 'ZENT' AND cod_tipo_interlocutor_especial = 'ZREL' THEN 'Relacionados'
      ELSE 'Terceros'
    END bp_grouping,
    nom_interlocutor,
    flg_cliente, 
    flg_bloqueo_cliente,
    flg_proveedor, 
    flg_bloqueo_proveedor,
    cod_pais, 
    cod_sociedad_global
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor`
  WHERE 
  --cod_grupo_interlocutor IN ('ZENT', 'ZINT') AND
  (flg_bloqueo_cliente IS NULL OR flg_bloqueo_proveedor IS NULL)
    AND des_origen = 'DE-WILSON'
),
base_documentos AS (
  SELECT
    id_interlocutor,
    cod_tipo_documento,
    des_numero_documento
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_documento`
  WHERE num_orden = 1
    AND des_origen = 'DE-WILSON'
),
datos_cuentas_contables AS (
  SELECT
    'Cliente' AS tipo_interlocutor,
    id_interlocutor,
    cod_sociedad,
    SAFE_CAST(SAFE_CAST(cod_cuenta_asociada AS INT64) AS STRING) AS cod_cuenta_asociada
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_cliente_sociedad`
  WHERE flg_bloqueo_sociedad IS NULL

  UNION ALL

  SELECT
    'Proveedor' AS tipo_interlocutor,
    id_interlocutor,
    cod_sociedad,
    SAFE_CAST(SAFE_CAST(cod_cuenta_asociada AS INT64) AS STRING) AS cod_cuenta_asociada
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_proveedor_sociedad`
  WHERE flg_bloqueo_sociedad IS NULL
),
base_final AS (
  SELECT 
    di.id_interlocutor_origen AS cod_interlocutor,
    di.cod_tipo_interlocutor_especial as tip_interlocutor_especial,
    di.cod_grupo_interlocutor as cod_grupo_interlocutor,
    di.bp_grouping as tip_bp_grouping,
    di.nom_interlocutor as des_nombre_interlocutor,
    di.flg_cliente, 
    di.flg_bloqueo_cliente,
    di.flg_proveedor,
    di.flg_bloqueo_proveedor,
    di.cod_pais, 
    di.cod_sociedad_global as cod_sociedad_gl,
    bd.cod_tipo_documento AS tipo_documento,
    bd.des_numero_documento AS numero_documento,
    dc.tipo_interlocutor,
    dc.cod_sociedad,
    dc.cod_cuenta_asociada,
    CASE 
      WHEN di.bp_grouping = 'Terceros'
        AND di.cod_sociedad_global IS NULL
        AND dc.tipo_interlocutor = 'Cliente' THEN '12'
      WHEN di.bp_grouping = 'Terceros'
        AND di.cod_sociedad_global IS NULL
        AND dc.tipo_interlocutor = 'Proveedor' THEN '42,44'
      WHEN di.bp_grouping = 'Intercompany'
        AND dc.tipo_interlocutor = 'Cliente' THEN '131220010,131120010,179101010,173221010'
      WHEN di.bp_grouping = 'Intercompany'
        AND dc.tipo_interlocutor = 'Proveedor' THEN '431220010'
      WHEN di.bp_grouping = 'Relacionados'
        AND dc.tipo_interlocutor = 'Cliente' THEN '131230010'
      WHEN di.bp_grouping = 'Relacionados'
        AND dc.tipo_interlocutor = 'Proveedor' THEN '431230010'
    END AS flag_cuenta_asociada
  FROM datos_interlcutor di
  INNER JOIN datos_cuentas_contables dc
    ON di.id_interlocutor = dc.id_interlocutor
  LEFT JOIN base_documentos bd
    ON di.id_interlocutor = bd.id_interlocutor
 -- WHERE dc.cod_sociedad NOT IN ('PE13', 'PE20')
)
SELECT 
  'DE-WILSON' AS des_origen,
  ROW_NUMBER() OVER(
    ORDER BY cod_interlocutor, tipo_interlocutor, cod_sociedad
  ) AS val_rownum,
  cod_interlocutor,
  tip_interlocutor_especial,
  cod_grupo_interlocutor,
  tip_bp_grouping,
  des_nombre_interlocutor,
  flg_cliente,
  flg_bloqueo_cliente,
  flg_proveedor,
  flg_bloqueo_proveedor,
  cod_pais,
  cod_sociedad_gl,
  tipo_documento,
  numero_documento,
  tipo_interlocutor,
  cod_sociedad,
  cod_cuenta_asociada,
  flag_cuenta_asociada,
  COALESCE(cod_interlocutor, '')
    || COALESCE(tipo_interlocutor, '')
    || COALESCE(cod_sociedad, '') AS val_dbkey
FROM base_final;