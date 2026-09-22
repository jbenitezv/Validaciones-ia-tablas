/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_MATERIAL_CENTRO_PRODUCTO_TERMINADO
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/



DELETE FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
WHERE des_origen = 'DE-WILSON';

INSERT INTO `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`

WITH 
datos_comercial AS (
  SELECT 
    id_material, 
    cod_sociedad,
    cod_negocio,
    des_negocio AS des_negocio,
    cod_subnegocio,
    des_subnegocio AS des_subnegocio,
    cod_marca,
    cod_grupo_imputacion,
    ROW_NUMBER() OVER(
      PARTITION BY id_material
      ORDER BY CASE WHEN cod_sociedad='PE11' THEN 1 ELSE 2 END, cod_sociedad
    ) AS val_rn
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_organizacion_venta`
),

datos_negocio AS (
  SELECT 
    id_material, 
    cod_negocio,
    des_negocio, 
    cod_subnegocio,
    des_subnegocio, 
    cod_marca, 
    cod_grupo_imputacion
  FROM datos_comercial
  WHERE val_rn=1
),

-- centros_produccion AS (
--   SELECT 
--     id_material,
--     STRING_AGG(DISTINCT cod_centro, ',') AS cod_centros_produccion
--   FROM `{silver_project_id}.slv_modelo_produccion.horizonte_lista_material_cabecera`
--   GROUP BY 1
-- ),

datos_material AS (
  SELECT 
    id_material, 
    cod_material_funcional,
    cod_material_reemplazo,
    cod_bloqueo
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_aux`
),

datos_centro AS (
  SELECT
    mb.id_material,
    mb.cod_material,
    mb.cod_tipo_material,
    mc.tip_material_fabricacion,
    mb.des_material AS des_denominacion_material, 
    CASE 
      WHEN (
        LEFT(mb.des_material,3) IN ('LAM','LÁM','EMP','ENV') 
        OR LEFT(mb.des_material,2)='SE' 
        OR LEFT(mb.des_material,5)='SOBRE'
      ) THEN 'Empaque-Envase'
      WHEN (
        LEFT(mb.des_material,3) IN ('CAJ','BAL','BLD')
        OR LEFT(mb.des_material,2)='CJ'
      ) THEN 'Caja-Balde'
      WHEN (
        LEFT(mb.des_material,2) IN ('TC','SF')
        OR LEFT(mb.des_material,5) IN ('TERMO','STREC')
      ) THEN 'Termocontraible'
    END AS des_presentacion_2,
    mb.flg_materia_prima AS flg_materia_prima,
    mb.cod_jerarquia,
    mb.des_plataforma AS des_plataforma,
    mb.des_subplataforma AS des_subplataforma,
    mb.des_categoria AS des_categoria,
    mb.des_familia AS des_familia,
    mb.des_variedad AS des_variedad,
    mb.des_presentacion AS des_presentacion,
    mb.cod_grupo_articulo,
    mb.des_grupo_articulo,
    mb.cod_grupo_articulo_3 AS cod_grupo_articulo_3,
    mb.cod_unidad_base,
    mb.cod_duenio_marca AS cod_propietario_marca,
    mc.cod_centro,
    mc.cod_sociedad,
    mc.cod_pais,
    mb.cod_grupo_transporte,
    mb.num_tiempo_vida AS val_tiempo_vida,
    mc.cod_unidad_medida_almacenamiento AS cod_unidad_almacenamiento,
    mc.cod_indicador_control_precio,
    mc.cod_categoria_valoracion,
    mc.cod_caracteristica_planificacion,
    mc.cod_clase_aprovisionamiento,
    mc.cod_planificacion_necesidad,
    mc.cod_grupo_compra,
    mc.num_tiempo_entrega_previsto AS num_tiempo_entrega_previsto,
    mc.cod_almacen_aprovisionamiento_externo,
    mc.cod_almacen_produccion,
    mc.cod_grupo_importacion_exportacion,
    mc.cod_tipo_aprovisionamiento_especial, 
    mc.cod_aprovisionamiento_especial, 
    mc.des_aprovisionamiento_especial,
    mc.cod_centro_origen,
    mc.cod_sociedad_origen,
    SAFE_CAST(NULL AS STRING) AS cod_centros_produccion, --cp.cod_centros_produccion,
    CASE WHEN mc2.id_material IS NOT NULL THEN TRUE ELSE FALSE END AS flg_extendido_centro_origen,
    mc.cod_grupo_carga,
    mc.cod_grupo_tratamiento_logistico,
    mc.cod_grupo_planificacion,
    dn.cod_negocio,
    dn.des_negocio,
    dn.cod_subnegocio,
    dn.des_subnegocio,
    dn.cod_marca,
    dn.cod_grupo_imputacion,
    mc.cod_estado_mantenimiento,
    CASE WHEN mc.flg_vista_compra = 1 THEN TRUE ELSE FALSE END AS flg_compras,
    CASE WHEN mc.flg_vista_venta = 1 THEN TRUE ELSE FALSE END AS flg_ventas,
    CASE
      WHEN mb.cod_tipo_material='ZROH'
       AND mc.cod_caracteristica_planificacion='PD'
       AND mb.des_material LIKE '%COMPRA'
      THEN TRUE
      ELSE NULL
    END AS flg_compra_2,
    mc.cod_centro_beneficio,
    mc.cod_indicador_impuesto,
    mc.num_tiempo_tratamiento_entrada_mercancia AS num_tiempo_trat_entrada_mercancia,
    mb.fec_creacion_material,
    mb.cod_usuario_creador,
    mb.fec_ultima_modificacion,
    mb.cod_usuario_ultima_modificacion,
    mc.cod_determinacion_precio,
    mc.cod_indicador_control_precio AS cod_indicador_control_precios,
    mc.num_precio_valorizado AS val_precio_actual,
    mc.num_cantidad_base AS val_cantidad_base,
    mc.val_precio_previo AS val_precio_anterior,
    mc.cod_grupo_gasto AS des_grupo_gasto_gral,
    mc.num_tamanio_lote AS val_tamanio_lote,
    mb.des_grupo_material1 AS des_grupo_materiales1,
    mb.des_grupo_material2 AS des_grupo_materiales2,
    mc.flg_estructura_cuantitativa AS flg_estructura_cuantitativa,
    mc.flg_material_origen AS flg_material_origen,
    mc.cod_tipo_valoracion,
    mc.flg_no_tiene_costo AS flg_no_tiene_costo,
    mc.flg_material_coproducto AS flg_material_coproducto,
    mc.flg_libro_material_activo AS flg_libro_materiales_activo,
    mb.flg_fert_hawa,
    mb.cod_estado AS est_status_fert_hawa,
    mc.cnt_stock_seguridad AS cnt_stock_seguridad,
    mc.cnt_lote_minimo AS cnt_lote_minimo,
    mc.num_valor_redondeo,
    mc.flg_suspension,
    dm.cod_material_reemplazo, 
    dm.cod_material_funcional,
    dm.cod_bloqueo,
    mc.cod_bloqueo_centro,
    mc.cod_material_reemplazante,
    CASE
      WHEN dm2.id_material IS NOT NULL THEN TRUE 
      ELSE FALSE
    END AS flg_codigo_material_reemplazante,
    mb.flg_excepcion_granel AS flg_excepcion_graneles,
    mc.des_planificacion_necesidad,
    mc.flg_pedido_automatico, 
    mc.cod_disponibilidad AS flg_disponibilidad,
    mc.cod_tamanio_lote
  FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_material` mb
  JOIN `{silver_project_id}.slv_modelo_material.horizonte_material_centro` mc
    ON mb.id_material=mc.id_material
  LEFT JOIN datos_negocio dn
    ON mb.id_material=dn.id_material
  -- LEFT JOIN centros_produccion cp
  --   ON mb.id_material=cp.id_material
  LEFT JOIN datos_material dm2
    ON mc.cod_material_reemplazante = dm2.cod_material_funcional
  LEFT JOIN datos_material dm
    ON mb.id_material=dm.id_material
  LEFT JOIN `{silver_project_id}.slv_modelo_material.horizonte_material_centro` mc2
    ON dm.id_material=mc2.id_material
   AND mc.cod_centro_origen=mc2.cod_centro
  --WHERE mc.cod_sociedad IN ('PE11','PE21','PE14','PE13','PE16') 
),

-- materiales_componentes AS (
--   SELECT DISTINCT id_material,cod_centro
--   FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_lista_material_componente`
-- ),

material_mrp_concatenado AS (
  SELECT 
    cod_material, 
    STRING_AGG(
      IF(cod_caracteristica_planificacion != 'ND', cod_caracteristica_planificacion, NULL)
    ) AS cod_caracteristicas_concatenadas
  FROM datos_centro
  GROUP BY cod_material
),

-- componentes_lmt_activas AS (
--   SELECT
--     cod_caracteristica_planificacion,
--     cod_material_componente,
--     cod_centro,
--     STRING_AGG(
--       CONCAT(
--         cod_tipo_material,'-',cod_material,'-',cod_centro,'-',
--         cod_alternativa_lista_material,'-',cod_posicion_componente
--       )
--     ) AS des_lista_materiales
--   FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_lista_material_componente`
--   WHERE cod_tipo_material_componente IN ('ZLER','ZROH')
--     AND cod_centro IN (
--       '1007','1011','1012','1014','1015','1016','1023','1024',
--       '1500','1501','1502','1503','1504','1505','1506','1507',
--       '1602','1603','1605','1606'
--     )
--   GROUP BY cod_material_componente,cod_centro,cod_caracteristica_planificacion
-- ),

-- componentes_lmt_activas_zfer AS (
--   SELECT
--     cod_caracteristica_planificacion,
--     cod_material_componente,
--     cod_centro,
--     cod_material
--   FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_lista_material_componente`
--   WHERE cod_tipo_material_componente IN ('ZFER')
--     AND cod_centro IN (
--       '1007','1011','1012','1014','1015','1016','1023','1024',
--       '1500','1501','1502','1503','1504','1505','1506','1507',
--       '1602','1603','1605','1606'
--     )
--   GROUP BY cod_material_componente,cod_centro,cod_caracteristica_planificacion,cod_material
-- ),

materiales_stock AS (
  SELECT DISTINCT
    ma.id_material,
    s4.cod_material_funcional,
    ma.cod_centro
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_almacen` ma
  LEFT JOIN `{silver_project_id}.slv_modelo_material.horizonte_material_aux` s4
    ON s4.id_material = ma.id_material
  WHERE cnt_stock_libre_utilizacion
      + cnt_stock_lotes_restringidos
      + cnt_stock_en_traslado
      + cnt_stock_bloqueado
      + cnt_stock_en_inspeccion_calidad
      + cnt_stock_en_devoluciones > 0
),

-- materiales_racio_cu03 AS (
--   SELECT DISTINCT cod_material, cod_centro
--   FROM (
--     SELECT
--       cod_material_padre AS cod_material,
--       cod_centro_padre AS cod_centro
--     FROM `alicorp-datalake.delivery_supply.materiales_alcance_producto_terminado`

--     UNION ALL

--     SELECT
--       cod_material_componente AS cod_material,
--       cod_centro_origen AS cod_centro
--     FROM `alicorp-datalake.delivery_supply.materiales_alcance_producto_terminado`
--   )
-- ),

-- recetas_activas AS (
--   SELECT
--     rc.id_material,
--     rc.cod_centro,
--     STRING_AGG(
--       CONCAT(s4.cod_material_funcional,'-',rc.cod_alternativa_receta)
--     ) AS cod_grupo_receta
--   FROM `{silver_project_id}.slv_modelo_produccion.horizonte_receta_cabecera` rc
--   LEFT JOIN `{silver_project_id}.slv_modelo_material.horizonte_material_aux` s4
--     ON rc.id_material=s4.id_material
--   WHERE est_receta='4'
--     AND num_version_fabricacion>=1
--   GROUP BY id_material,cod_centro
--),

-- base_fert_hawa AS (
--   SELECT DISTINCT 
--     cod_material, 
--     est_nuevo_material AS flg_status_nuevo, 
--     ind_exportacion
--   FROM `{golden_project_id}.gld_inventario.s4_material_fert_hawa`
-- ),

-- base_version_fabricacion AS (
--   SELECT DISTINCT
--     cod_material, 
--     cod_centro
--   FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_version_fabricacion`
-- ),

materiales_maquila AS (
  SELECT DISTINCT
    id_material
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_centro` dc
  WHERE dc.cod_planificacion_necesidad = 'TER'
),

material_centro_ampliado AS (
  SELECT DISTINCT
    cod_material,
    cod_centro
  FROM datos_centro
),

materiales_ucdm AS (
  SELECT DISTINCT 
    id_material
  FROM `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  WHERE cod_sociedad IN ('CO11','EC11','PE11','PE14','PE18','PE21')
),

base_final AS (
  SELECT DISTINCT
    dc.id_material,
    dc.cod_material,
    ms.cod_material_funcional AS flg_stock_material,
    dc.des_denominacion_material,
    dc.des_presentacion_2,
    dc.flg_materia_prima,
    dc.cod_tipo_material,
    dc.tip_material_fabricacion,
    dc.cod_jerarquia,
    dc.des_plataforma,
    dc.des_subplataforma,
    dc.des_categoria,
    dc.des_familia,
    dc.des_variedad,
    dc.des_presentacion,
    dc.cod_grupo_articulo,
    dc.des_grupo_articulo,
    dc.cod_grupo_articulo_3,
    dc.cod_propietario_marca,
    dc.cod_centro,
    dc.cod_sociedad,
    dc.cod_pais,
    dc.cod_grupo_transporte,
    dc.val_tiempo_vida,
    dc.cod_unidad_base,
    dc.cod_unidad_almacenamiento,
    dc.cod_indicador_control_precio,
    dc.cod_categoria_valoracion,
    SAFE_CAST(NULL AS STRING) AS cod_categoria_valoracion_recomendada,
    dc.cod_caracteristica_planificacion,
    CASE
      WHEN cpl.cod_caracteristica_planificacion IS NULL THEN FALSE
      ELSE TRUE
    END AS flg_caract_planificacion,
    dc.cod_clase_aprovisionamiento,
    dc.cod_planificacion_necesidad,
    dc.cod_grupo_compra,
    CASE
      WHEN grpc.cod_grupo_compra IS NULL THEN FALSE
      ELSE TRUE
    END AS flg_grupo_compras,
    dc.num_tiempo_entrega_previsto,
    dc.cod_almacen_aprovisionamiento_externo,
    dc.cod_almacen_produccion,
    dc.cod_grupo_importacion_exportacion,
    dc.cod_tipo_aprovisionamiento_especial,
    dc.cod_aprovisionamiento_especial,
    dc.des_aprovisionamiento_especial,
    dc.cod_centro_origen,
    dc.cod_sociedad_origen,
    dc.cod_centros_produccion,
    dc.flg_extendido_centro_origen,
    dc.cod_grupo_carga,
    dc.cod_grupo_tratamiento_logistico,
    dc.cod_grupo_planificacion,
    dc.cod_negocio,
    dc.cod_subnegocio,
    dc.cod_marca,
    dc.cod_grupo_imputacion,
    dc.cod_estado_mantenimiento,
    dc.flg_compras,
    dc.flg_ventas,
    dc.cod_centro_beneficio,
    CASE 
      WHEN TRIM(COALESCE(val_prctr.cod_centro_beneficio,''))='' THEN NULL
      ELSE val_prctr.cod_centro_beneficio
    END AS cod_centro_beneficio_propuesto,
    dc.cod_indicador_impuesto,
    dc.num_tiempo_trat_entrada_mercancia,
    dc.fec_creacion_material,
    CASE 
      WHEN dc.cod_tipo_material IN ('ZFER','ZHAW')
       AND dc.fec_creacion_material > '2024-03-11'
       AND ucdm.id_material IS NOT NULL THEN 'UCDM'
      WHEN dc.cod_tipo_material IN ('ZLER','ZROH')
       AND dc.fec_creacion_material > '2024-03-18'
       AND ucdm.id_material IS NOT NULL THEN 'UCDM'
      WHEN dc.cod_tipo_material IN ('ZERS','ZHIB','ZNLA')
       AND dc.fec_creacion_material >= '2024-07-01'
       AND ucdm.id_material IS NOT NULL THEN 'UCDM'
      WHEN dc.cod_tipo_material NOT IN ('ZFER','ZHAW','ZLER','ZROH','ZERS','ZHIB','ZNLA') THEN NULL 
      ELSE 'Planeamiento'
    END AS des_equipo_creador, 
    dc.cod_usuario_creador,
    dc.fec_ultima_modificacion,
    dc.cod_usuario_ultima_modificacion,
    dc.cod_determinacion_precio,
    cpr.flg_determinacion_precio AS val_determinacion_precio_correcto,
    dc.cod_indicador_control_precios,
    cpr.num_indicador_control_precio AS cod_indicador_control_precios_correcto,
    dc.val_precio_actual,
    dc.val_cantidad_base,
    dc.val_precio_anterior,
    CASE
      WHEN dc.val_precio_anterior!=0
      THEN ABS(dc.val_precio_actual/dc.val_precio_anterior - 1)
    END AS val_variacion_precio,
    CASE
      WHEN dc.val_cantidad_base!=0
      THEN ROUND(dc.val_precio_actual/dc.val_cantidad_base,4)
    END AS val_ratio_precio_base,
    dc.des_grupo_gasto_gral,
    dc.val_tamanio_lote,
    dc.des_grupo_materiales1,
    dc.des_grupo_materiales2,
    dc.flg_estructura_cuantitativa,
    dc.flg_material_origen,
    dc.cod_tipo_valoracion,
    dc.flg_no_tiene_costo,
    dc.flg_material_coproducto,
    dc.flg_libro_materiales_activo,

    SAFE_CAST(NULL AS BOOLEAN) AS flg_componente,

    dc.flg_fert_hawa,
    dc.est_status_fert_hawa,

    SAFE_CAST(NULL AS BOOLEAN) flg_racio_cu03,
    -- CASE 
    --   WHEN cu03.cod_material IS NOT NULL THEN TRUE
    --   ELSE FALSE 
    -- END AS flg_racio_cu03,

    dc.des_negocio,
    dc.des_subnegocio,
    cb.val_centro_beneficio_digito AS cod_centro_beneficio_digito_567,

    CASE
      WHEN dc.cod_caracteristica_planificacion IN ('YD')
       AND dc.num_tiempo_entrega_previsto>4 THEN FALSE
      WHEN dc.cod_caracteristica_planificacion IN ('ZD')
       AND dc.num_tiempo_entrega_previsto<=4 THEN FALSE
      ELSE TRUE
    END AS flg_tipo_mrp,

    dc.cnt_stock_seguridad,
    dc.cnt_lote_minimo,
    dc.num_valor_redondeo,
    dc.flg_suspension,
    dc.cod_material_reemplazo AS cod_material_reemplazo,
    dc.cod_material_funcional,
    dc.cod_bloqueo,

    CASE
      WHEN SUBSTRING(dc.cod_grupo_tratamiento_logistico,4,1) IN ('6')
       AND num_tiempo_entrega_previsto<=60 THEN TRUE
      WHEN SUBSTRING(dc.cod_grupo_tratamiento_logistico,4,1) IN ('7')
       AND num_tiempo_entrega_previsto<=30 THEN TRUE
      ELSE FALSE
    END AS flg_leadtime,

    -- CASE 
    --   WHEN ra.id_material IS NOT NULL THEN TRUE 
    --   ELSE FALSE 
    -- END AS flg_receta,

    -- ra.cod_grupo_receta,

    SAFE_CAST(NULL AS BOOLEAN) AS flg_receta,
    SAFE_CAST(NULL AS STRING) AS cod_grupo_receta,

    dc.cod_bloqueo_centro,

    CASE
      WHEN (
        SUBSTRING(dc.cod_grupo_tratamiento_logistico,4,1) IN ('1','2','3','4','5','6')
        AND dc.cod_tipo_material='ZLER'
      )
      OR (
        SUBSTRING(dc.cod_grupo_tratamiento_logistico,4,1) IN ('1','2','3','4','5','7')
        AND dc.cod_tipo_material='ZROH'
      ) THEN TRUE
      ELSE FALSE
    END AS flg_grp_trat_log,

    dc.cod_material_reemplazante,

    CASE
      WHEN dc.cod_centro IN (
        '1007','1011','1012','1014','1015','1016','1023','1024',
        '1500','1501','1502','1503','1504','1505','1506','1507',
        '1602','1603','1605','1606'
      ) THEN TRUE
      ELSE FALSE
    END AS flg_centro_ibp,

    dc.flg_excepcion_graneles,
    dc.des_planificacion_necesidad,

    CASE
      WHEN (
        dc.cod_grupo_compra IN ('324','312')
        AND dc.cod_clase_aprovisionamiento='F'
        AND dc.cod_aprovisionamiento_especial IS NULL
      )
      OR (
        dc.cod_grupo_compra NOT IN ('324','312')
        AND dc.cod_aprovisionamiento_especial!='30'
        AND dc.cod_aprovisionamiento_especial IS NULL
      ) THEN FALSE
      ELSE TRUE
    END AS flg_aprov,

    CASE 
      WHEN num_tiempo_entrega_previsto <=15
       AND dc.cod_caracteristica_planificacion='ZD'
       AND dc.cod_grupo_tratamiento_logistico='0002' THEN TRUE
      WHEN num_tiempo_entrega_previsto >=15
       AND dc.cod_caracteristica_planificacion='YD'
       AND dc.cod_grupo_tratamiento_logistico='0002' THEN TRUE
      ELSE FALSE
    END AS flg_leadtime_mrp,

    SAFE_CAST(NULL AS BOOLEAN) AS flg_tipo_mrp_2,
    SAFE_CAST(NULL AS STRING) AS cod_version_fabricacion,
    SAFE_CAST(NULL AS STRING) AS est_nuevo,

    'Hadjie Tarazona' AS des_responsable_material_indirecto,

    CASE
      WHEN crd.des_categoria = 'Harinas'
       AND dc.cod_centro = '1015' THEN 'Alexander'
      WHEN crd.des_categoria IS NULL THEN 'Sin responsable'
      ELSE crd.des_responsable 
    END AS des_responsable_distribucion

  FROM datos_centro dc

  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_categoria_responsable_distribucion` crd 
    ON UPPER(crd.des_categoria) = UPPER(dc.des_categoria)

  LEFT JOIN materiales_maquila mmq
    ON dc.id_material = mmq.id_material

  LEFT JOIN material_centro_ampliado mca
    ON dc.cod_material = mca.cod_material
   AND dc.cod_centro_origen = mca.cod_centro

  LEFT JOIN material_mrp_concatenado mrc
    ON dc.cod_material = mrc.cod_material

  -- LEFT JOIN base_fert_hawa fh
  --   ON REGEXP_REPLACE(dc.cod_material,'^0+','')
  --    = REGEXP_REPLACE(fh.cod_material,'^0+','')

  -- LEFT JOIN base_version_fabricacion vfab
  --   ON vfab.cod_material = dc.cod_material
  --  AND vfab.cod_centro = dc.cod_centro

  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_material_grupo_compra` grpc
    ON dc.cod_tipo_material=grpc.cod_tipo_material 
   AND dc.cod_grupo_compra=grpc.cod_grupo_compra
   AND dc.cod_grupo_articulo_3=grpc.cod_grupo_articulo

  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_material_caracteristica_planificacion` cpl
    ON dc.cod_tipo_material=cpl.cod_tipo_material 
   AND COALESCE(dc.flg_compra_2,'')=COALESCE(cpl.flg_compra,'') 
   AND dc.cod_caracteristica_planificacion=cpl.cod_caracteristica_planificacion

  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_homologacion_jerarquia_centro_beneficio` val_prctr
    ON dc.cod_tipo_material IN ('ZFER','ZHAW') 
   AND LEFT(dc.cod_jerarquia,7)=val_prctr.cod_categoria 
   AND dc.cod_negocio=val_prctr.cod_negocio 
   AND dc.cod_subnegocio=val_prctr.cod_subnegocio

  LEFT JOIN `{silver_project_id}.slv_gobierno.rtr_costo_control_precio` cpr
    ON dc.cod_tipo_material=cpr.cod_tipo_material
   AND dc.cod_categoria_valoracion=cpr.cod_categoria_valoracion

  -- LEFT JOIN componentes_lmt_activas mla 
  --   ON dc.cod_material = mla.cod_material_componente

  -- LEFT JOIN componentes_lmt_activas_zfer mlaz 
  --   ON dc.cod_material = mlaz.cod_material_componente 

  -- LEFT JOIN materiales_componentes mc
  --   ON dc.id_material=mc.id_material
  --  AND dc.cod_centro=mc.cod_centro

  LEFT JOIN materiales_stock ms
    ON dc.id_material=ms.id_material
   AND dc.cod_centro=ms.cod_centro

  -- LEFT JOIN materiales_racio_cu03 cu03
  --   ON dc.cod_material=cu03.cod_material
  --  AND dc.cod_centro=cu03.cod_centro

  -- LEFT JOIN recetas_activas ra
  --   ON dc.id_material=ra.id_material
  --  AND dc.cod_centro=ra.cod_centro

  LEFT JOIN `{silver_project_id}.slv_gobierno.ptp_material_grupo_produccion_centro_beneficio` cb
    ON dc.cod_negocio=cb.cod_negocio

  -- LEFT JOIN `{horizonte_project_id}.hzt_planeamiento.horizonte_version_fabricacion` vb
  --   ON mlaz.cod_material=vb.cod_material
  --  AND mlaz.cod_centro=vb.cod_centro

  LEFT JOIN materiales_ucdm ucdm
    ON dc.id_material=ucdm.id_material

  --WHERE dc.cod_sociedad<>'PE13'
)

SELECT
  'DE-WILSON' AS des_origen,
  ROW_NUMBER() OVER(ORDER BY cod_material,cod_centro) AS val_rownum,
  id_material,
  cod_material,
  flg_stock_material,
  des_denominacion_material,
  des_presentacion_2,
  flg_materia_prima,
  cod_tipo_material,
  tip_material_fabricacion,
  cod_jerarquia,
  des_plataforma,
  des_subplataforma,
  des_categoria,
  des_familia,
  des_variedad,
  des_presentacion,
  cod_grupo_articulo,
  des_grupo_articulo,
  cod_grupo_articulo_3,
  cod_propietario_marca,
  cod_centro,
  cod_sociedad,
  cod_pais,
  cod_grupo_transporte,
  val_tiempo_vida,
  cod_unidad_base,
  cod_unidad_almacenamiento,
  cod_indicador_control_precio,
  cod_categoria_valoracion,
  cod_categoria_valoracion_recomendada,
  cod_caracteristica_planificacion,
  flg_caract_planificacion,
  cod_clase_aprovisionamiento,
  cod_planificacion_necesidad,
  cod_grupo_compra,
  flg_grupo_compras,
  num_tiempo_entrega_previsto,
  cod_almacen_aprovisionamiento_externo,
  cod_almacen_produccion,
  cod_grupo_importacion_exportacion,
  cod_tipo_aprovisionamiento_especial,
  cod_aprovisionamiento_especial,
  des_aprovisionamiento_especial,
  cod_centro_origen,
  cod_sociedad_origen,
  cod_centros_produccion,
  flg_extendido_centro_origen,
  cod_grupo_carga,
  cod_grupo_tratamiento_logistico,
  cod_grupo_planificacion,
  cod_negocio,
  cod_subnegocio,
  cod_marca,
  cod_grupo_imputacion,
  cod_estado_mantenimiento,
  flg_compras,
  flg_ventas,
  cod_centro_beneficio,
  cod_centro_beneficio_propuesto,
  cod_indicador_impuesto,
  num_tiempo_trat_entrada_mercancia,
  fec_creacion_material,
  des_equipo_creador,
  cod_usuario_creador,
  fec_ultima_modificacion,
  cod_usuario_ultima_modificacion,
  cod_determinacion_precio,
  val_determinacion_precio_correcto,
  cod_indicador_control_precios,
  cod_indicador_control_precios_correcto,
  val_precio_actual,
  val_cantidad_base,
  val_precio_anterior,
  val_variacion_precio,
  val_ratio_precio_base,
  des_grupo_gasto_gral,
  val_tamanio_lote,
  des_grupo_materiales1,
  des_grupo_materiales2,
  flg_estructura_cuantitativa,
  flg_material_origen,
  cod_tipo_valoracion,
  flg_no_tiene_costo,
  flg_material_coproducto,
  flg_libro_materiales_activo,
  flg_componente,
  flg_fert_hawa,
  est_status_fert_hawa,
  flg_racio_cu03,
  des_negocio,
  des_subnegocio,
  cod_centro_beneficio_digito_567,
  flg_tipo_mrp,
  cnt_stock_seguridad,
  cnt_lote_minimo,
  num_valor_redondeo,
  flg_suspension,
  cod_material_reemplazo,
  cod_material_funcional,
  cod_bloqueo,
  flg_leadtime,
  flg_receta,
  cod_grupo_receta,
  cod_bloqueo_centro,
  flg_grp_trat_log,
  cod_material_reemplazante,
  flg_centro_ibp,
  flg_excepcion_graneles,
  des_planificacion_necesidad,
  flg_aprov,
  flg_leadtime_mrp,
  flg_tipo_mrp_2,
  cod_version_fabricacion,
  est_nuevo,
  des_responsable_material_indirecto,
  des_responsable_distribucion,
  cod_material || COALESCE(cod_centro,'') AS val_dbkey,
  CURRENT_DATETIME('America/Lima') AS fec_proceso
FROM base_final
--WHERE cod_centro!='D999'
;

MERGE INTO `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado` t
USING (
  SELECT 
    cod_tipo_material,
    cod_centro_beneficio
  FROM `{silver_project_id}.slv_gobierno.ptp_material_homologacion_tipo_material`
  WHERE cod_tipo_material IN ('ZHIB','ZUNB','ZLEI','ZERS')
) s
ON (
  t.des_origen='DE-WILSON'
  AND t.cod_tipo_material=s.cod_tipo_material
  AND t.cod_centro_beneficio=s.cod_centro_beneficio
)
WHEN MATCHED THEN
UPDATE SET 
  t.cod_centro_beneficio_propuesto=s.cod_centro_beneficio;


MERGE INTO `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado` t
USING (
  SELECT 
    cod_tipo_material,
    cod_grupo_articulo,
    cod_categoria_valoracion
  FROM `{silver_project_id}.slv_gobierno.ptp_material_categoria_valoracion`
  WHERE cod_tipo_material IN ('ZROH','ZWER','ZLER','ZLEI','ZHIB','ZERS','ZHAW')
) s
ON (
  t.des_origen='DE-WILSON'
  AND t.cod_tipo_material=s.cod_tipo_material
  AND t.est_grupo_articulo_3=s.cod_grupo_articulo
)
WHEN MATCHED THEN
UPDATE SET 
  t.cod_categoria_valoracion_recomendada=s.cod_categoria_valoracion;


UPDATE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
SET cod_categoria_valoracion_recomendada=cod_categoria_valoracion
WHERE des_origen='DE-WILSON'
  AND cod_tipo_material='ZROH'
  AND est_grupo_articulo_3='X'
  AND cod_categoria_valoracion='3002'
  AND cod_categoria_valoracion_recomendada='3004';


MERGE INTO `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado` t
USING (
  SELECT 
    cod_tipo_material,
    cod_grupo_articulo,
    cod_categoria_valoracion
  FROM `{silver_project_id}.slv_gobierno.ptp_material_categoria_valoracion_no_almacen`
  WHERE cod_tipo_material IN ('ZNLA')
) s
ON (
  t.des_origen='DE-WILSON'
  AND t.cod_tipo_material=s.cod_tipo_material
  AND LEFT(t.cod_grupo_articulo,3)=s.cod_grupo_articulo
)
WHEN MATCHED THEN
UPDATE SET 
  t.cod_categoria_valoracion_recomendada=s.cod_categoria_valoracion;


UPDATE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
SET cod_categoria_valoracion_recomendada='7900'
WHERE des_origen='DE-WILSON'
  AND cod_tipo_material='ZHAL'
  AND cod_material IN (
    SELECT DISTINCT cod_material
    FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
    WHERE des_origen='DE-WILSON'
      AND cod_tipo_material='ZHAL'
      AND (
        cod_clase_aprovisionamiento IN ('E','X')
        OR (
          cod_clase_aprovisionamiento='F'
          AND cod_aprovisionamiento_especial='30'
        )
      )
  );


UPDATE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
SET cod_categoria_valoracion_recomendada='7920'
WHERE des_origen='DE-WILSON'
  AND cod_tipo_material='ZFER'
  AND cod_material IN (
    SELECT DISTINCT cod_material
    FROM `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
    WHERE des_origen='DE-WILSON'
      AND cod_tipo_material='ZFER'
      AND cod_clase_aprovisionamiento='E'
      AND cod_aprovisionamiento_especial IS NULL
  );


UPDATE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
SET cod_categoria_valoracion_recomendada='7921'
WHERE des_origen='DE-WILSON'
  AND cod_tipo_material='ZFER' 
  AND cod_planificacion_necesidad='TER'
  AND (
    (
      cod_aprovisionamiento_especial IS NULL
      AND cod_clase_aprovisionamiento='F'
    )
    OR cod_aprovisionamiento_especial='30'
  )
  AND cod_categoria_valoracion_recomendada IS NULL;


UPDATE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
SET cod_categoria_valoracion_recomendada=
  CASE 
    WHEN cod_tipo_material='ZFER' THEN '3006'
    WHEN cod_tipo_material='ZHAL' THEN '3007'
  END
WHERE des_origen='DE-WILSON'
  AND cod_tipo_material IN ('ZFER','ZHAL') 
  AND cod_sociedad_origen IS NOT NULL
  AND cod_centro!=cod_centro_origen
  AND cod_caracteristica_planificacion IN ('YD','ZD');


UPDATE `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_producto_terminado`
SET cod_categoria_valoracion_recomendada='0'
WHERE des_origen='DE-WILSON'
  AND cod_categoria_valoracion_recomendada IS NULL;