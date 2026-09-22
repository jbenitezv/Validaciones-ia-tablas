/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_MATERIAL_PROVEEDOR
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{silver_project_id}.hzt_planeamiento.horizonte_material_proveedor`
WHERE des_origen = 'DE-WILSON';

INSERT INTO `{silver_project_id}.hzt_planeamiento.horizonte_material_proveedor`

WITH

-- cuotas_vigentes AS (
--   SELECT DISTINCT
--     cod_material,
--     cod_centro,
--     cod_cuenta_proveedor,
--     cod_fichero_cuota
--   FROM `{silver_project_id}.hzt_compras.horizonte_fichero_cuota_detalle`
--   WHERE fec_fin_validez >= CURRENT_DATE()
-- ),

-- base_contrato AS (
--   SELECT
--     ekko.id_documento_origen,
--     ekko.cod_tipo_compra,
--     ekko.cod_proveedor,
--     ekko.cod_organizacion_compra,
--     ekko.fec_inicio_validez_documento,
--     ekko.fec_fin_validez_documento,
--     ekpo.id_material,
--     ekpo.cod_tipo_material,
--     ekpo.cod_centro,
--     ekpo.cod_categoria_articulo,
--     ekko.cod_indicador_borrado
--   FROM `{silver_project_id}.slv_modelo_compra.horizonte_documento_cabecera` ekko
--   JOIN `{silver_project_id}.slv_modelo_compra.horizonte_documento_detalle` ekpo
--     ON ekpo.id_documento = ekko.id_documento
--   WHERE ekko.periodo >= DATE '2021-01-01'
--     AND ekpo.periodo >= DATE '2021-01-01'
--     AND ekko.fec_fin_validez_documento >= CURRENT_DATE()
--     AND ekko.cod_tipo_compra IN ('ZLP','ZWK')
--     AND ekpo.cod_categoria_articulo = '2'
--     AND ekko.cod_indicador_borrado IS NULL
-- ),

universo AS (
  SELECT DISTINCT 
    m.id_material_origen AS cod_material, 
    mc.id_material, 
    m.des_material, 
    m.cod_tipo_material,
    SAFE_CAST(NULL AS STRING) AS des_categoria, -- mj.des_categoria
    cod_centro
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_centro` mc
  LEFT JOIN `{silver_project_id}.slv_modelo_material.horizonte_material` m
    ON m.id_material = mc.id_material
   AND m.des_origen = 'SAPS4'

  -- LEFT JOIN `{silver_project_id}.slv_modelo_material.horizonte_material_jerarquia` mj
  --   ON m.cod_jerarquia_material = mj.cod_jerarquia_material
),

base_final AS (
  SELECT DISTINCT
    u.cod_material, 
    u.des_material, 
    u.cod_tipo_material, 
    u.des_categoria,
    u.cod_centro,

    SAFE_CAST(NULL AS STRING) AS cod_cuenta_proveedor, -- cv.cod_cuenta_proveedor
    SAFE_CAST(NULL AS BOOLEAN) AS flg_cuenta_proveedor,

    SAFE_CAST(NULL AS STRING) AS cod_proveedor, -- bc.cod_proveedor
    SAFE_CAST(NULL AS STRING) AS cod_organizacion_compra, -- bc.cod_organizacion_compra
    SAFE_CAST(NULL AS BOOLEAN) AS flg_proveedor,

    SAFE_CAST(NULL AS STRING) AS cod_categoria_registro_compra, -- ri2.cod_categoria_registro_compra
    SAFE_CAST(NULL AS NUMERIC) AS num_plazo_entrega_previsto_cuota, -- ri.num_plazo_entrega_previsto
    SAFE_CAST(NULL AS NUMERIC) AS num_plazo_entrega_previsto_contrato -- ri2.num_plazo_entrega_previsto

  FROM universo u

  -- LEFT JOIN cuotas_vigentes cv 
  --   ON u.cod_material = cv.cod_material 
  --  AND u.cod_centro = cv.cod_centro

  -- LEFT JOIN base_contrato bc
  --   ON u.id_material = bc.id_material
  --  AND u.cod_centro = bc.cod_centro 

  -- LEFT JOIN `{silver_project_id}.slv_modelo_compra.horizonte_registro_informacion` ri
  --   ON u.id_material = ri.id_material
  --  AND u.cod_centro = ri.cod_centro
  --  AND cv.cod_cuenta_proveedor = ri.cod_proveedor
  --  AND ri.periodo IS NOT NULL

  -- LEFT JOIN `{silver_project_id}.slv_modelo_compra.horizonte_registro_informacion` ri2
  --   ON u.id_material = ri2.id_material
  --  AND u.cod_centro = ri2.cod_centro
  --  AND bc.cod_proveedor = ri2.cod_proveedor
  --  AND bc.cod_organizacion_compra = ri2.cod_organizacion_compra
  --  AND ri2.periodo IS NOT NULL
  --  AND ri2.cod_categoria_registro_compra = '2'
)

SELECT
  'DE-WILSON' AS des_origen,
  ROW_NUMBER() OVER(
    ORDER BY cod_material, cod_centro, cod_proveedor
  ) AS val_rownum,
  'PE11' AS cod_sociedad,
  cod_material,
  des_material,
  cod_tipo_material,
  des_categoria,
  cod_centro,
  cod_cuenta_proveedor,
  flg_cuenta_proveedor,
  cod_proveedor,
  cod_organizacion_compra,
  flg_proveedor,
  cod_categoria_registro_compra,
  num_plazo_entrega_previsto_cuota,
  num_plazo_entrega_previsto_contrato,
  cod_material || cod_centro || COALESCE(cod_proveedor,'') AS val_dbkey,
  CURRENT_DATETIME('America/Lima') AS fec_proceso
FROM base_final
WHERE 1=1
--And (flg_cuenta_proveedor is TRUE OR flg_proveedor is TRUE);