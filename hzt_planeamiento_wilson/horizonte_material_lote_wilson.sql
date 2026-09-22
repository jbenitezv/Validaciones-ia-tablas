/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_LOTE
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_material_lote`
WHERE des_origen = 'DE-WILSON';

INSERT INTO `{horizonte_project_id}.hzt_planeamiento.horizonte_material_lote`
WITH
datos_material AS (
  SELECT
    s4.id_material,
    s4.cod_material_funcional,
    s4.cod_tipo_material,
    s4.des_material AS des_denominacion_material,
    s4.num_duracion_total AS num_tiempo_vida_util,
    s4.cod_unidad_tiempo AS cod_unidad_tiempo,
    s4.num_tiempo_duracion AS num_tiempo_minimo_duracion,
    s4.num_duracion_total AS num_duracion_total_conservacion
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_aux` s4
  WHERE COALESCE(s4.cod_bloqueo,'') != '03'
),

-- materiales_racio_cu03 AS (
--   SELECT DISTINCT cod_material
--   FROM (
--     SELECT cod_material_padre AS cod_material
--     FROM `alicorp-datalake.delivery_supply.materiales_alcance_producto_terminado`

--     UNION ALL

--     SELECT cod_material_componente AS cod_material
--     FROM `alicorp-datalake.delivery_supply.materiales_alcance_producto_terminado`
--   )
-- ),

datos_centro AS (
  SELECT
    id_material,
    cod_centro,
    cod_sociedad,
    cod_pais
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  WHERE COALESCE(cod_bloqueo_centro,'') != '03'
),

datos_lote AS (
  SELECT
    id_material,
    cod_centro,
    cod_almacen,
    cod_lote,
    cod_centro_produccion,
    fec_creacion,
    fec_vencimiento,
    fec_produccion,
    cnt_stock_libre_utilizacion AS cnt_stock_libre_utilizacion,
    cnt_stock_lotes_restringidos AS cnt_stock_lotes_restringidos,
    cnt_stock_en_traslado AS cnt_stock_en_traslado,
    cnt_stock_bloqueado AS cnt_stock_bloqueado,
    cnt_stock_en_inspeccion_calidad AS cnt_stock_en_inspeccion_calidad
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_lote`
  -- WHERE cnt_stock_libre_utilizacion
  --     + cnt_stock_lotes_restringidos
  --     + cnt_stock_en_traslado
  --     + cnt_stock_bloqueado
  --     + cnt_stock_en_inspeccion_calidad
  --     + cnt_stock_en_devoluciones > 0
),

datos_material_unidad_medida AS (
  SELECT *
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_unidad_medida`
  -- WHERE cod_unidad_medida = 'PAL'
),

base_lotes AS (
  SELECT
    dl.id_material,
    dm.cod_material_funcional AS cod_material,
    dm.des_denominacion_material,
    dm.cod_tipo_material,
    dl.cod_centro,
    dc.cod_sociedad,
    dc.cod_pais,
    dl.cod_almacen,
    dl.cod_lote,
    dl.cod_centro_produccion,
    CASE
      WHEN dl.cod_lote LIKE '%LATAM%' THEN FALSE
      WHEN dl.cod_lote LIKE '%X_UNICO%' THEN FALSE
      WHEN dl.cod_lote LIKE '%FX' THEN FALSE
      ELSE TRUE
    END AS flg_codigo_lote,
    dl.fec_creacion,
    dl.fec_vencimiento,
    dl.fec_produccion,
    dm.num_tiempo_minimo_duracion,
    dm.num_duracion_total_conservacion,
    dm.num_tiempo_vida_util,
    dm.cod_unidad_tiempo,
    CASE
      WHEN dm.cod_unidad_tiempo = 'D'
        AND MOD(dm.num_tiempo_vida_util,30) = 0
      THEN SAFE_CAST(ROUND(dm.num_tiempo_vida_util/30) AS INT64)
      ELSE dm.num_tiempo_vida_util
    END AS num_tiempo_vida_util_2,
    CASE
      WHEN dm.cod_unidad_tiempo = 'D'
        AND MOD(dm.num_tiempo_vida_util,30) = 0
      THEN 'M'
      ELSE dm.cod_unidad_tiempo
    END AS cod_unidad_tiempo_2,
    LEFT(dl.cod_lote,6) AS cod_primeros_dig_lote,
    dl.cnt_stock_libre_utilizacion,
    dl.cnt_stock_lotes_restringidos,
    dl.cnt_stock_en_traslado,
    dl.cnt_stock_bloqueado,
    dl.cnt_stock_en_inspeccion_calidad
  FROM datos_lote dl
  JOIN datos_material dm
    ON dl.id_material = dm.id_material
  JOIN datos_centro dc
    ON dl.id_material = dc.id_material
   AND dl.cod_centro = dc.cod_centro
  WHERE COALESCE(dl.fec_vencimiento,CURRENT_DATE('America/Lima')) >= CURRENT_DATE('America/Lima')
),

base_final AS (
  SELECT
    b.id_material,
    b.cod_material,
    b.des_denominacion_material,
    b.cod_tipo_material,
    b.cod_centro,
    'null' AS des_descripcion_centro,
    b.cod_sociedad,
    'null' AS nom_nombre_sociedad,
    b.cod_pais,
    b.cod_almacen,
    b.cod_lote,
    b.cod_centro_produccion,
    b.flg_codigo_lote,
    b.fec_creacion,
    b.fec_vencimiento,
    b.fec_produccion,
    b.num_tiempo_minimo_duracion,
    b.num_duracion_total_conservacion,
    b.num_tiempo_vida_util,
    b.cod_unidad_tiempo,
    CASE cod_unidad_tiempo_2
      WHEN 'A' THEN DATE_ADD(fec_creacion, INTERVAL SAFE_CAST(num_tiempo_vida_util_2 AS INT64) YEAR)
      WHEN 'M' THEN DATE_ADD(fec_creacion, INTERVAL SAFE_CAST(num_tiempo_vida_util_2 AS INT64) MONTH)
      WHEN 'S' THEN DATE_ADD(fec_creacion, INTERVAL SAFE_CAST(num_tiempo_vida_util_2 AS INT64) WEEK)
      WHEN 'D' THEN DATE_ADD(fec_creacion, INTERVAL SAFE_CAST(num_tiempo_vida_util_2 AS INT64) DAY)
    END AS fec_vencimiento_max,
    b.cod_primeros_dig_lote,
    CASE
      WHEN cod_unidad_tiempo = 'D' THEN SAFE_CAST(DATE_DIFF(fec_vencimiento, fec_produccion, DAY) AS NUMERIC)
      WHEN cod_unidad_tiempo = 'M' THEN dtg_proceso_calidad.fnt_diferencia_mes(fec_vencimiento, fec_produccion)
      WHEN cod_unidad_tiempo = 'A' THEN dtg_proceso_calidad.fnt_diferencia_mes(CURRENT_DATE('America/Lima'), b.fec_produccion)/12
      WHEN cod_unidad_tiempo = 'S' THEN SAFE_CAST(DATE_DIFF(fec_vencimiento, fec_produccion, WEEK) AS NUMERIC)
    END AS val_d,
    CASE
      WHEN cod_unidad_tiempo = 'M' THEN dtg_proceso_calidad.fnt_diferencia_mes(CURRENT_DATE('America/Lima'), b.fec_produccion)
      WHEN cod_unidad_tiempo = 'D' THEN SAFE_CAST(DATE_DIFF(CURRENT_DATE('America/Lima'), b.fec_produccion, DAY) AS NUMERIC)
      WHEN cod_unidad_tiempo = 'A' THEN dtg_proceso_calidad.fnt_diferencia_mes(CURRENT_DATE('America/Lima'), b.fec_produccion)/12
      WHEN cod_unidad_tiempo = 'S' THEN SAFE_CAST(DATE_DIFF(CURRENT_DATE('America/Lima'), b.fec_produccion, WEEK) AS NUMERIC)
    END AS num_tiempo_vida_util_real,
    b.cnt_stock_libre_utilizacion,
    b.cnt_stock_lotes_restringidos,
    b.cnt_stock_en_traslado,
    b.cnt_stock_bloqueado,
    b.cnt_stock_en_inspeccion_calidad,
    d.num_numerador_conversion,
    -- CASE
    --   WHEN cu03.cod_material IS NOT NULL THEN 1
    --   ELSE 0
    -- END AS flg_racio_cu03,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_racio_cu03,
    DATE_ADD(
      b.fec_vencimiento,
      INTERVAL SAFE_CAST(-b.num_tiempo_vida_util AS INT64) DAY
    ) AS fec_prod2,
    CASE
      WHEN b.cod_primeros_dig_lote != RIGHT(FORMAT_DATE('%Y%m%d', b.fec_creacion), 6)
        OR SUBSTRING(b.cod_lote, 8, 2) != SUBSTRING(b.cod_centro_produccion,3, 2)
      THEN FALSE
      ELSE TRUE
    END AS flg_estructura_lote
  FROM base_lotes b
  LEFT JOIN datos_material_unidad_medida d
    ON b.id_material = d.id_material
  -- LEFT JOIN materiales_racio_cu03 cu03
  --   ON b.cod_material = cu03.cod_material
),

base_final_2 AS (
  SELECT
    *,
    ROUND(num_tiempo_vida_util - num_tiempo_vida_util_real,2) AS num_tiempo_maximo_sku_almacen
  FROM base_final
)

SELECT
  'DE-WILSON' AS des_origen,
  ROW_NUMBER() OVER(
    ORDER BY cod_material, cod_centro, cod_lote
  ) AS val_rownum,
  *,
  cod_material
    || COALESCE(cod_centro,'')
    || COALESCE(cod_almacen,'')
    || COALESCE(cod_lote,'') AS val_dbkey
FROM base_final_2;
