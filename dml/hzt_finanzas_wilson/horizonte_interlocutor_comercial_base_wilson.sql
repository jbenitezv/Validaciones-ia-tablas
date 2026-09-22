/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_INTERLOCUTOR_COMERCIAL_BASE.
  FECHA DE CREACIÓN: 17/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_finanzas.horizonte_interlocutor_comercial_base`
WHERE des_origen = 'DE-WILSON';

INSERT INTO `{horizonte_project_id}.hzt_finanzas.horizonte_interlocutor_comercial_base`
WITH 
gl_cliente AS (
  SELECT
    id_interlocutor,
    cod_sociedad_global AS sociedad_gl_cliente
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor`
  WHERE flg_cliente = 'X'
    AND des_origen = 'DE-WILSON'
),
gl_proveedor AS (
  SELECT
    id_interlocutor,
    cod_sociedad_global AS sociedad_gl_proveedor
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor`
  WHERE flg_proveedor = 'X'
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
datos_interlocutor AS (
  SELECT 
    id_interlocutor, 
    id_interlocutor_origen, 
    cod_tipo_interlocutor_especial, 
    cod_grupo_interlocutor, 
    CASE
      WHEN cod_grupo_interlocutor = 'ZINT' THEN 'Intercompany' 
      WHEN cod_grupo_interlocutor = 'ZENT' AND cod_tipo_interlocutor_especial = 'ZREL' THEN 'Relacionados'
      ELSE 'Terceros'
    END AS bp_grouping,
    nom_interlocutor,
    flg_cliente, 
    flg_bloqueo_cliente,
    flg_proveedor, 
    flg_bloqueo_proveedor,
    cod_pais, 
    cod_sociedad_global
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor`
  WHERE
  --  cod_grupo_interlocutor IN ('ZENT', 'ZINT') AND 
    (flg_bloqueo_cliente IS NULL OR flg_bloqueo_proveedor IS NULL)
    AND des_origen = 'DE-WILSON'
),
datos_sociedad AS (
  SELECT
    id_interlocutor,
    cod_sociedad
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_proveedor_sociedad`
  WHERE flg_bloqueo_sociedad IS NULL

  UNION ALL

  SELECT
    id_interlocutor,
    cod_sociedad
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_cliente_sociedad` soc
  WHERE flg_bloqueo_sociedad IS NULL
),
sociedad_priorizada AS (
  SELECT 
    i.id_interlocutor,
    i.cod_pais,
    s.cod_sociedad,
    pri.num_prioridad,
    ROW_NUMBER() OVER(
      PARTITION BY i.id_interlocutor 
      ORDER BY 
        IF(LENGTH(i.id_interlocutor_origen)=4,0,1),
        IF(i.cod_pais=LEFT(s.cod_sociedad,2),1,9),
        COALESCE(pri.num_prioridad,99)
    ) AS rn
  FROM `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor` i
  INNER JOIN datos_sociedad s
    ON i.id_interlocutor = s.id_interlocutor
  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_prioridad_sociedad` pri
    ON s.cod_sociedad = pri.cod_sociedad
),
base_final AS (
  SELECT 
    ib.id_interlocutor_origen AS cod_interlocutor,
    ib.cod_grupo_interlocutor,
    ib.cod_tipo_interlocutor_especial AS tip_interlocutor_especial,
    ib.bp_grouping as tip_bp_grouping,
    ib.nom_interlocutor as des_nombre_interlocutor,
    ib.flg_cliente, 
    ib.flg_bloqueo_cliente,
    ib.flg_proveedor, 
    ib.flg_bloqueo_proveedor,
    COALESCE(sp.cod_sociedad, 'PE11') AS cod_sociedad,
    ib.cod_pais,
    bd.cod_tipo_documento,
    bd.des_numero_documento,
    cl.sociedad_gl_cliente as cod_sociedad_gl_cliente,
    pr.sociedad_gl_proveedor as cod_sociedad_gl_proveedor,
    CASE 
      WHEN ib.bp_grouping = 'Terceros' 
        AND cl.sociedad_gl_cliente IS NULL 
        AND pr.sociedad_gl_proveedor IS NULL THEN 1
      WHEN ib.bp_grouping = 'Intercompany' 
        AND (
          LEFT(cl.sociedad_gl_cliente,2)=ib.cod_pais 
          OR LEFT(pr.sociedad_gl_proveedor,2)=ib.cod_pais
        ) THEN 1
      WHEN ib.bp_grouping = 'Relacionados' 
        AND (
          LEFT(cl.sociedad_gl_cliente,2) IN ('GR','AS') 
          OR LEFT(pr.sociedad_gl_proveedor,2) IN ('GR','AS')
        ) THEN 1
      ELSE 0 
    END AS flag_sociedad_gl
  FROM datos_interlocutor ib
  LEFT JOIN base_documentos bd
    ON ib.id_interlocutor = bd.id_interlocutor
  LEFT JOIN gl_cliente cl
    ON ib.id_interlocutor = cl.id_interlocutor
  LEFT JOIN gl_proveedor pr
    ON ib.id_interlocutor = pr.id_interlocutor
  LEFT JOIN sociedad_priorizada sp
    ON sp.rn = 1 
    AND ib.id_interlocutor = sp.id_interlocutor
)
SELECT 
  'DE-WILSON' AS des_origen,
  ROW_NUMBER() OVER(ORDER BY cod_interlocutor) AS val_rownum,
  cod_interlocutor,
  cod_grupo_interlocutor,
  tip_interlocutor_especial,
  tip_bp_grouping,
  des_nombre_interlocutor,
  flg_cliente,
  flg_bloqueo_cliente,
  flg_proveedor,
  flg_bloqueo_proveedor,
  cod_sociedad,
  cod_pais,
  cod_tipo_documento,
  des_numero_documento,
  cod_sociedad_gl_cliente,
  cod_sociedad_gl_proveedor,
  flag_sociedad_gl,
  COALESCE(cod_interlocutor, '') AS val_dbkey
FROM base_final;