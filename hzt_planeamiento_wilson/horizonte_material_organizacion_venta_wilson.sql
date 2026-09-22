/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_MATERIAL_ORGANIZACION_VENTA
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

DELETE FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_material_organizacion_venta`
WHERE des_origen = 'DE-WILSON';

INSERT INTO `{horizonte_project_id}.hzt_planeamiento.horizonte_material_organizacion_venta`
WITH
marc AS (
  SELECT 
    id_material,
    cod_estado_mantenimiento
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  WHERE COALESCE(cod_bloqueo_centro,'') != '03'
    AND cod_centro != 'D999'
),
vistas AS (
  SELECT
    id_material,
    MAX(CASE WHEN cod_estado_mantenimiento LIKE '%E%' THEN TRUE ELSE FALSE END) AS flg_compras,
    MAX(CASE WHEN cod_estado_mantenimiento LIKE '%V%' THEN TRUE ELSE FALSE END) AS flg_ventas
  FROM marc
  GROUP BY id_material
),
uco AS (
  SELECT 
    id_material,
    cod_unidad_comercial AS cod_unidad_comercial_material,
    SAFE_CAST(num_numerador_conversion_unidad_comercial AS INT64) AS num_numerador_conversion_uco,
    SAFE_CAST(num_denominador_conversion_unidad_comercial AS INT64) AS num_denominador_conversion_uco
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_aux`
  WHERE COALESCE(cod_bloqueo,'') != '03'
    -- AND cod_unidad_comercial IS NOT NULL
),
-- mlan AS (
--   SELECT
--     id_material,
--     cod_pais,
--     cod_clasificacion_impuesto_1 AS cod_clasif_impuesto_1,
--     cod_clasificacion_impuesto_2 AS cod_clasif_impuesto_2, 
--     cod_clasificacion_impuesto_3 AS cod_clasif_impuesto_3
--   FROM `{silver_project_id}.slv_modelo_material.horizonte_material_impuesto`
-- ),
cebes AS (
  SELECT
    cv.id_material,
    cv.cod_sociedad,
    ps.num_prioridad AS num_prioridad,
    cv.cod_centro_beneficio,
    ROW_NUMBER() OVER(
      PARTITION BY cv.id_material
      ORDER BY ps.num_prioridad
    ) AS val_rownum
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_centro` cv
  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_prioridad_sociedad` ps
    ON cv.cod_sociedad = ps.cod_sociedad
  --WHERE 
    -- cv.cod_tipo_material IN ('ZFER','ZHAW')
    -- AND cv.cod_centro != 'D999'
    -- AND cv.cod_centro_beneficio IS NOT NULL
),
cebe_principal AS (
  SELECT
    id_material,
    cod_centro_beneficio
  FROM cebes
  WHERE val_rownum = 1
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
datos_material AS (
  SELECT
    mb.id_material,
    mb.cod_material,
    mb.cod_tipo_material,
    mb.des_material,
    mb.cod_jerarquia,
    mb.cod_plataforma,
    mb.cod_subplataforma,
    mb.cod_categoria,
    mb.des_categoria,
    mb.des_familia,
    mb.cod_familia,
    mb.cod_variedad,
    mb.cod_presentacion,
    mb.cod_grupo_articulo,
    mb.des_grupo_articulo,
    mb.cod_grupo_articulo_3,
    mb.cod_duenio_marca,
    mb.cod_grupo_transporte,
    CASE 
      WHEN vi.flg_compras = 1 THEN TRUE
      WHEN vi.flg_compras = 0 THEN FALSE
    END AS flg_compras,
    CASE 
      WHEN vi.flg_ventas = 1 THEN TRUE
      WHEN vi.flg_ventas = 0 THEN FALSE
    END AS flg_ventas,
    ov.cod_organizacion_venta,
    ov.cod_canal_distribucion,
    ov.cod_pais,
    ov.cod_sociedad,
    ov.cod_grupo_imputacion,
    ov.des_grupo_imputacion AS des_grupo_imputacion,
    ov.cod_negocio,
    ov.des_negocio AS des_negocio,
    ov.cod_subnegocio,
    ov.des_subnegocio AS des_subnegocio,
    ov.cod_marca,
    ov.des_marca AS des_marca,
    ov.cod_unidad_comercial AS cod_unidad_comercial_org_venta,
    uc.cod_unidad_comercial_material,
    mb.cod_unidad_base,
    uc.num_numerador_conversion_uco,
    uc.num_denominador_conversion_uco,
    CASE
      WHEN ov.cod_indicador_impuestos = '' THEN NULL
      ELSE ov.cod_indicador_impuestos
    END AS cod_indicador_impuestos,
    ov.des_indicador_impuestos,
    SAFE_CAST(NULL AS STRING) AS cod_clasif_impuesto_1,-- ml.cod_clasif_impuesto_1,
    SAFE_CAST(NULL AS STRING) AS cod_clasif_impuesto_2,-- ml.cod_clasif_impuesto_2, 
    SAFE_CAST(NULL AS STRING) AS cod_clasif_impuesto_3,-- ml.cod_clasif_impuesto_3,
    cp.cod_centro_beneficio,
    mb.fec_creacion_material,
    mb.cod_usuario_creador,
    mb.fec_ultima_modificacion,
    mb.cod_usuario_ultima_modificacion,
    mb.flg_fert_hawa,
    mb.cod_estado AS cod_estado_fert_hawa,
    -- CASE 
    --   WHEN cu03.cod_material IS NOT NULL THEN TRUE
    --   ELSE FALSE 
    -- END AS flg_racio_cu03,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_racio_cu03,
    ov.cod_tier,
    ov.des_tier,
    mb.des_equipo_creador,
    mb.cod_estado_nuevo,
    mb.flg_exclusion_categoria_valorizacion,
    ov.cod_jerarquia_material
  FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_material` mb
  JOIN `{silver_project_id}.slv_modelo_material.horizonte_material_organizacion_venta` ov
    ON mb.id_material = ov.id_material
  LEFT JOIN vistas vi
    ON mb.id_material = vi.id_material
  LEFT JOIN uco uc
    ON mb.id_material = uc.id_material
  -- LEFT JOIN mlan ml
  --   ON mb.id_material = ml.id_material
  --  AND ov.cod_pais = ml.cod_pais
  LEFT JOIN cebe_principal cp
    ON mb.id_material = cp.id_material
  -- LEFT JOIN materiales_racio_cu03 cu03
  --   ON mb.cod_material = cu03.cod_material
  -- WHERE 
  --   COALESCE(ov.cod_bloqueo_comercial,'') != '01'
  --   AND ov.cod_sociedad IN ('PE11','PE21','PE14','PE16')
),
base_peru AS (
  SELECT DISTINCT 
    cod_material
  FROM datos_material
  --WHERE cod_sociedad LIKE 'PE%'
),
base_mrp_activos AS (
  SELECT DISTINCT 
    id_material 
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  WHERE cod_sociedad LIKE 'PE%' 
    AND (
      (cod_tipo_material IN ('ZFER','ZHAW') AND cod_caracteristica_planificacion IN ('XD','ZM','YD'))
      OR (cod_tipo_material IN ('ZLER','ZROH') AND cod_caracteristica_planificacion IN ('YD','ZD'))
      OR (cod_tipo_material IN ('ZHAL') AND cod_caracteristica_planificacion IN ('MZ','ZM'))
    )
),
base_final AS (
  SELECT 
    dm.id_material,
    dm.cod_material,
    dm.cod_tipo_material,
    dm.des_material,
    dm.cod_jerarquia,
    dm.cod_plataforma,
    dm.cod_subplataforma,
    dm.cod_categoria,
    dm.des_categoria,
    dm.des_familia,
    dm.cod_familia,
    dm.cod_variedad,
    dm.cod_presentacion,
    dm.cod_grupo_articulo,
    dm.des_grupo_articulo,
    dm.cod_grupo_articulo_3,
    dm.cod_duenio_marca,
    dm.cod_grupo_transporte,
    dm.flg_compras AS flg_compra,
    dm.flg_ventas AS flg_venta,
    dm.cod_organizacion_venta,
    dm.cod_canal_distribucion,
    dm.cod_pais,
    dm.cod_sociedad,
    dm.cod_grupo_imputacion,
    dm.des_grupo_imputacion AS des_grupo_imputacion,
    dm.cod_negocio,
    dm.des_negocio AS des_negocio,
    dm.cod_subnegocio,
    dm.des_subnegocio AS des_subnegocio,
    dm.cod_marca,
    dm.des_marca AS des_marca,
    dm.cod_unidad_comercial_org_venta AS cod_unidad_comercial_organizacion_venta,
    dm.cod_unidad_comercial_material AS cod_unidad_comercial_material,
    dm.cod_unidad_base,
    dm.num_numerador_conversion_uco AS num_numerador_conversion_unidad_comercial,
    dm.num_denominador_conversion_uco AS num_denominador_conversion_unidad_comercial,
    dm.cod_indicador_impuestos AS cod_indicador_impuesto,
    dm.des_indicador_impuestos AS des_indicador_impuesto,
    dm.cod_clasif_impuesto_1 AS cod_clasificacion_impuesto_1,
    dm.cod_clasif_impuesto_2 AS cod_clasificacion_impuesto_2,
    dm.cod_clasif_impuesto_3 AS cod_clasificacion_impuesto_3,
    CASE
      WHEN im.cod_pais IS NULL THEN FALSE
      ELSE TRUE
    END AS flg_clasificacion_impuesto,
    dm.cod_centro_beneficio,
    cb.val_centro_beneficio_digito AS val_centro_beneficio_digito_567,
    dm.fec_creacion_material,
    dm.cod_usuario_creador,
    dm.fec_ultima_modificacion,
    dm.cod_usuario_ultima_modificacion,
    dm.flg_fert_hawa,
    dm.cod_estado_fert_hawa,
    dm.flg_racio_cu03 AS flg_racionalizacion_caso_uso_03,
    dm.cod_tier,
    dm.des_tier,
    dm.des_equipo_creador,
    dm.cod_estado_nuevo,
    dm.flg_exclusion_categoria_valorizacion,
    f.est_relacion_familia_marca,
    CASE 
      WHEN bp.cod_material IS NOT NULL THEN TRUE
      ELSE FALSE 
    END AS flg_sociedad,
    CASE 
      WHEN mrp.id_material IS NOT NULL THEN TRUE
      ELSE FALSE 
    END AS flg_mrp_activo,
    dm.cod_jerarquia_material
  FROM datos_material dm
  LEFT JOIN base_mrp_activos mrp
    ON dm.id_material = mrp.id_material
  LEFT JOIN base_peru bp 
    ON bp.cod_material = dm.cod_material
  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_pais_impuesto` im
    ON dm.cod_pais = im.cod_pais
   AND CASE WHEN dm.cod_clasif_impuesto_1 IS NOT NULL THEN 'X' ELSE '' END = COALESCE(im.flg_impuesto_1,'')
   AND CASE WHEN dm.cod_clasif_impuesto_2 IS NOT NULL THEN 'X' ELSE '' END = COALESCE(im.flg_impuesto_2,'')
   AND CASE WHEN dm.cod_clasif_impuesto_3 IS NOT NULL THEN 'X' ELSE '' END = COALESCE(im.flg_impuesto_3,'')
  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_material_grupo_produccion_centro_beneficio` cb
    ON dm.cod_negocio = cb.cod_negocio
  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_familia_marca` f
    ON dm.des_categoria = f.des_categoria
   AND dm.cod_familia = f.cod_familia
   AND dm.cod_marca = f.cod_marca
)
SELECT
  'DE-WILSON' AS des_origen,
  ROW_NUMBER() OVER(
    ORDER BY cod_material, cod_organizacion_venta, cod_canal_distribucion
  ) AS val_rownum,
  *,
  cod_material
    || COALESCE(cod_organizacion_venta,'')
    || COALESCE(cod_canal_distribucion,'') AS val_dbkey,
  CURRENT_DATETIME('America/Lima') AS fec_proceso
FROM base_final;