/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_MATERIAL_CENTRO_VALIRACION
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
where des_origen = 'DE-WILSON';

insert into `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
with
datos_comercial as (
  select 
    id_material, 
    cod_sociedad,
    cod_negocio,
    des_negocio as des_negocio,
    cod_subnegocio,
    des_subnegocio as des_subnegocio,
    cod_marca,
    cod_grupo_imputacion,
    row_number()over(partition by id_material order by case when cod_sociedad='PE11' then 1 else 2 end, cod_sociedad) as val_rn
  from `{silver_project_id}.slv_modelo_material.horizonte_material_organizacion_venta`
  where coalesce(cod_bloqueo_comercial,'')!='01'
),
datos_negocio as (
  select 
    id_material, 
    cod_negocio,
    des_negocio, 
    cod_subnegocio,
    des_subnegocio, 
    cod_marca, 
    cod_grupo_imputacion
  from datos_comercial
  where val_rn=1
),
-- centros_produccion as (
--   select 
--     id_material,
--     string_agg(distinct cod_centro, ',') as cod_centros_produccion
--   from `{silver_project_id}.slv_modelo_produccion.horizonte_lista_material_cabecera`
--   where flg_version_fabricacion>0
--   group by 1
-- ),
datos_material as (
  select 
    id_material, 
    cod_material_funcional,
    cod_material_reemplazo,
    cod_planner,
    cod_valor_compra
  from `{silver_project_id}.slv_modelo_material.horizonte_material_aux`
),
datos_centro as (
  select
    mb.id_material,
    mb.cod_material,
    mb.cod_tipo_material,
    mc.tip_material_fabricacion,
    mb.des_material as des_denominacion_material,
    case 
      when (
        left(mb.des_material,3) in ('LAM','LÁM','EMP','ENV') 
          or left(mb.des_material,2)='SE' 
            or left(mb.des_material,5)='SOBRE'
        ) then 'Empaque-Envase'
      when (
        left(mb.des_material,3) in ('CAJ','BAL','BLD')
          or left(mb.des_material,2)='CJ'
        ) then 'Caja-Balde'
      when (
        left(mb.des_material,2) in ('TC','SF')
          or left(mb.des_material,5) in ('TERMO','STREC')
        ) then 'Termocontraible'
    end as des_presentacion_2,
    mb.flg_materia_prima as flg_materia_prima,
    mb.cod_jerarquia,
    mb.cod_plataforma,
    mb.des_plataforma as des_plataforma,
    mb.des_subplataforma as des_subplataforma,
    mb.des_categoria as des_categoria,
    mb.des_familia as des_familia,
    mb.des_variedad as des_variedad,
    mb.des_presentacion as des_presentacion,
    mb.cod_grupo_articulo,
    mb.des_grupo_articulo,
    mb.cod_grupo_articulo_3 as cod_grupo_articulo_3,
    mb.cod_unidad_base,
    mb.cod_duenio_marca as cod_propietario_marca,
    mc.cod_centro,
    mc.cod_sociedad,
    mc.cod_pais,
    mb.cod_grupo_transporte,
    mb.num_tiempo_vida as val_tiempo_vida,
    mc.cod_unidad_medida_almacenamiento as cod_unidad_almacenamiento,
    mc.cod_indicador_control_precio,
    mc.cod_categoria_valoracion,
    mc.cod_caracteristica_planificacion,
    mc.cod_clase_aprovisionamiento,
    mc.cod_planificacion_necesidad,
    mc.cod_grupo_compra,
    mc.num_tiempo_entrega_previsto as num_tiempo_entrega_previsto,
    mc.cod_almacen_aprovisionamiento_externo,
    mc.cod_almacen_produccion,
    mc.cod_grupo_importacion_exportacion,
    mc.cod_tipo_aprovisionamiento_especial,
    mc.cod_aprovisionamiento_especial,
    mc.des_aprovisionamiento_especial,
    mc.cod_centro_origen,
    mc.cod_sociedad_origen,
    --cp.cod_centros_produccion,
    SAFE_CAST(NULL AS STRING) AS cod_centros_produccion,
    case when mc2.id_material is not null then true else false end as flg_extendido_centro_origen,
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
    case
      when mc.flg_vista_compra = 1 then true
      else false
    end as flg_compras,
    case
      when mc.flg_vista_venta = 1 then true
      else false
    end as flg_ventas,
    case when mb.cod_tipo_material ='ZROH' and mc.cod_caracteristica_planificacion='PD' and mb.des_material like '%COMPRA' then TRUE else null end as flg_compra_2,
    mc.cod_centro_beneficio,
    mc.cod_indicador_impuesto,
    mc.num_tiempo_tratamiento_entrada_mercancia as num_tiempo_trat_entrada_mercancia,
    mb.fec_creacion_material,
    mb.cod_usuario_creador,
    mb.fec_ultima_modificacion,
    mb.cod_usuario_ultima_modificacion,
    mc.cod_determinacion_precio,
    mc.cod_indicador_control_precio as cod_indicador_control_precios,
    mc.num_precio_valorizado as val_precio_actual,
    mc.num_cantidad_base as val_cantidad_base,
    mc.val_precio_previo as val_precio_anterior,
    mc.cod_grupo_gasto as des_grupo_gasto_gral,
    mc.num_tamanio_lote as val_tamanio_lote,
    mb.des_grupo_material1 as des_grupo_materiales1,
    mb.des_grupo_material2 as des_grupo_materiales2,
    mc.flg_estructura_cuantitativa as flg_estructura_cuantitativa,
    mc.flg_material_origen as flg_material_origen,
    mc.cod_tipo_valoracion,
    mc.flg_no_tiene_costo as flg_no_tiene_costo,
    mc.flg_material_coproducto as flg_material_coproducto,
    mc.flg_libro_material_activo as flg_libro_materiales_activo,
    mb.flg_fert_hawa,
    mb.cod_estado as est_status_fert_hawa,
    mc.cnt_stock_seguridad as cnt_stock_seguridad,
    mc.cnt_lote_minimo as cnt_lote_minimo,
    mc.num_valor_redondeo,
    mc.flg_suspension,
    dm.cod_material_reemplazo,
    dm.cod_material_funcional,
    dm.cod_planner,
    dm.cod_valor_compra,
    mc.cod_bloqueo_centro,
    mc.cod_material_reemplazante,
    case
      when dm2.id_material is not null then true 
      else false
    end as flg_codigo_material_reemplazante,
    mb.flg_excepcion_granel as flg_excepcion_graneles,
    mc.des_planificacion_necesidad,
    mc.flg_pedido_automatico, 
    mc.cod_disponibilidad as flg_disponibilidad,
    mc.cod_tamanio_lote,
    mb.num_tiempo_duracion,
    mc.mnt_precio_plan,
    mc.val_fecha_plan
  from `{horizonte_project_id}.hzt_planeamiento.horizonte_material` mb
  join `{silver_project_id}.slv_modelo_material.horizonte_material_centro` mc
    on mb.id_material=mc.id_material
  left join datos_negocio dn
    on mb.id_material=dn.id_material
  -- left join centros_produccion cp
  --   on mb.id_material=cp.id_material
  left join datos_material dm2
    on mc.cod_material_reemplazante = dm2.cod_material_funcional
  left join datos_material dm
    on mb.id_material=dm.id_material
  left join `{silver_project_id}.slv_modelo_material.horizonte_material_centro` mc2
    on dm.id_material=mc2.id_material
      and mc.cod_centro_origen=mc2.cod_centro
  where coalesce(mc.cod_bloqueo_centro,'')!='03'
  -- and mc.cod_sociedad in ('PE11','PE21','PE14','PE13','PE16') 
),

-- materiales_componentes as (
--   select distinct id_material,cod_centro
--   from `{horizonte_project_id}.hzt_planeamiento.horizonte_lista_material_componente`
-- ),

material_mrp_concatenado as (
  SELECT 
    cod_material, 
    STRING_AGG(
      IF(cod_caracteristica_planificacion != 'ND', cod_caracteristica_planificacion, NULL)
    ) AS cod_caracteristicas_concatenadas
  FROM datos_centro
  GROUP BY cod_material
),

-- componentes_lmt_activas as (
--   select
--     cod_caracteristica_planificacion,
--     cod_material_componente,
--     cod_centro,
--     string_agg(CONCAT(cod_tipo_material,'-',cod_material,'-',cod_centro,'-',cod_alternativa_lista_material,'-',cod_posicion_componente)) as des_lista_materiales
--   from `{horizonte_project_id}.hzt_planeamiento.horizonte_lista_material_componente`
--   where cod_tipo_material_componente in ('ZLER','ZROH','ZHAL')
--   and cod_centro in ('1007','1011','1012','1014','1015','1016','1023','1024','1500','1501','1502','1503','1504','1505','1506','1507','1602','1603','1605','1606')
--   group by cod_material_componente,cod_centro,cod_caracteristica_planificacion
-- ),

materiales_stock as (
  select distinct
    ma.id_material,
    s4.cod_material_funcional,
    ma.cod_centro
  from `{silver_project_id}.slv_modelo_material.horizonte_material_almacen` ma
  left join `{silver_project_id}.slv_modelo_material.horizonte_material_aux` s4
    on s4.id_material = ma.id_material
  where cnt_stock_libre_utilizacion
      + cnt_stock_lotes_restringidos
      + cnt_stock_en_traslado
      + cnt_stock_bloqueado
      + cnt_stock_en_inspeccion_calidad
      + cnt_stock_en_devoluciones > 0
),
-- materiales_racio_cu03 as (
--   select distinct cod_material, cod_centro
--   from (
--     select cod_material_padre as cod_material, cod_centro_padre as cod_centro
--     from `alicorp-datalake.delivery_supply.materiales_alcance_producto_terminado`
--     union all
--     select cod_material_componente as cod_material, cod_centro_origen as cod_centro
--     from `alicorp-datalake.delivery_supply.materiales_alcance_producto_terminado`
--   )
-- ),
-- recetas_activas as (
--   select
--     rc.id_material,
--     rc.cod_centro,
--     string_agg(CONCAT(s4.cod_material_funcional,'-',rc.cod_alternativa_receta)) as cod_grupo_receta
--   from `{silver_project_id}.slv_modelo_produccion.horizonte_receta_cabecera` rc
--   left join `{silver_project_id}.slv_modelo_material.horizonte_material_aux` s4
--     on rc.id_material=s4.id_material
--   where est_receta='4'
--   and num_version_fabricacion>=1
--   group by id_material,cod_centro
-- ),

-- base_fert_hawa as (
--   select distinct 
--     cod_material, 
--     est_nuevo_material as flg_status_nuevo,
--     ind_exportacion
--   from `{golden_project_id}.gld_inventario.s4_material_fert_hawa`
-- ),

-- base_version_fabricacion as (
--   select distinct
--     id_material, 
--     cod_centro,
--     fec_fin_validez, 
--     flg_bloqueo
--   from `{silver_project_id}.slv_modelo_produccion.horizonte_version_fabricacion`
-- ),
materiales_maquila as (
  select distinct
    id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro` dc
  where dc.cod_planificacion_necesidad = 'TER'
),
material_centro_ampliado_zfer as (
  select distinct cod_material, cod_centro
  from datos_centro
  where cod_caracteristica_planificacion in ('ZM','YD','XD')
),
material_centro_ampliado_zhal as (
  select distinct cod_material, cod_centro
  from datos_centro
  where cod_caracteristica_planificacion in ('ZM','MZ')
),
maquilas_full_cost as (
  select distinct
    id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro` dc
  where dc.cod_planificacion_necesidad = 'TER'
  and dc.cod_caracteristica_planificacion = 'XD'
),
-- componentes_zhal_listas_ferhal as (
--   select distinct
--     lmc.cod_material_componente as cod_material,
--     lmc.cod_centro_origen as cod_centro
--   from `{silver_project_id}.slv_modelo_produccion.horizonte_lista_material_cabecera` lc 
--   left join `{silver_project_id}.slv_modelo_produccion.horizonte_lista_material_componente_historico` lmc
--     on lc.cod_lista_material = lmc.cod_lista_material
--     and lc.cod_alternativa_lista_material = lmc.cod_alternativa_lista_material
--   left join `{silver_project_id}.slv_modelo_produccion.horizonte_version_fabricacion` vf 
--     on vf.id_material = lc.id_material
--     and lc.cod_centro = vf.cod_centro
--     and lc.cod_alternativa_lista_material = vf.cod_alternativa_lista_material
--   left join `{silver_project_id}.slv_modelo_material.horizonte_material_centro` mc 
--     on mc.id_material = lc.id_material
--     and mc.cod_centro = lc.cod_centro
--   where mc.cod_tipo_material in ('ZFER','ZHAL')
--   and vf.flg_bloqueo is null
--   and vf.fec_fin_validez >= current_date()
-- ),
-- componentes_en_lm_activas as (
--   select distinct 
--     cod_material_componente as cod_material
--   from `{silver_project_id}.slv_modelo_produccion.horizonte_lista_material_componente_historico` mc 
--   left join `{silver_project_id}.slv_modelo_produccion.horizonte_version_fabricacion` vf 
--     on vf.id_material = concat('MAT-DE-WILSON-', REGEXP_EXTRACT(mc.id_lista_material_componente, r'^[^-\n]*-[^-\n]*-([^-\n]*)'))
--     and vf.flg_bloqueo is null
--     and vf.fec_fin_validez >= current_date()
--   where est_componente_vigente not in ('0')
--   and vf.id_material is not null
-- ),

-- componentes_en_lm_activas_v2 as (
--   select distinct 
--     cod_material_componente as cod_material
--   from `{horizonte_project_id}.hzt_planeamiento.horizonte_lista_material_componente` lmc
--   left join `{silver_project_id}.slv_modelo_material.horizonte_material_aux` maux
--     on maux.cod_material_funcional = lmc.cod_material 
--   left join `{silver_project_id}.slv_modelo_material.horizonte_material_centro` dc
--     on dc.id_material = maux.id_material
--     and dc.cod_centro = lmc.cod_centro
--   where lmc.flg_version_activa is true
-- ),

materiales_ucdm as (
  select distinct 
    id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  where cod_sociedad in ('CO11', 'EC11', 'PE11', 'PE14', 'PE18', 'PE21')
),

-- listas_zhal_activas as (
--   select distinct 
--     cod_material, 
--     cod_centro
--   from `{horizonte_project_id}.hzt_planeamiento.horizonte_lista_material_componente`
--   where cod_tipo_material = 'ZHAL' 
--   and flg_version_activa is TRUE
-- ),

materiales_cantidad_stock as (
  select distinct 
    id_material,
    cod_centro,
    SUM(
      cnt_stock_libre_utilizacion
      + cnt_stock_lotes_restringidos
      + cnt_stock_en_traslado
      + cnt_stock_bloqueado
      + cnt_stock_en_inspeccion_calidad
      + cnt_stock_en_devoluciones
    ) as cnt_stock
  from `{silver_project_id}.slv_modelo_material.horizonte_material_almacen`
  group by 1,2
),

-- base_fecha_inicio as (
--   select distinct
--     cod_material,
--     max(fec_inicio_extrema) as fec_inicio_extrema_maxima
--   from `{silver_project_id}.slv_modelo_produccion.horizonte_orden_produccion_cabecera`
--   group by 1
-- ),

responsables_material_centro as (
  select distinct
    cod_material, 
    cod_centro, 
    des_responsable, 
    row_number() over(partition by cod_material, cod_centro order by des_responsable) as val_ranking
  from `{silver_project_id}.slv_gobierno.ptp_material_responsable`
),
responsable_categoria_pprod as (
  select distinct 
    des_categoria, 
    des_responsable, 
    substring(id_categoria_responsable,8) as nom_des_responsable_ip
  from `{silver_project_id}.slv_gobierno.ptp_categoria_responsable_produccion`
),
base_final as (
  select distinct
    dc.id_material,
    dc.cod_material,
    ms.cod_material_funcional as flg_stock_material,
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
    SAFE_CAST(NULL AS STRING) AS des_centro, -- mac.des_centro,
    dc.cod_sociedad,
    dc.cod_pais,
    dc.cod_grupo_transporte,
    dc.val_tiempo_vida,
    dc.cod_unidad_base,
    dc.cod_unidad_almacenamiento,
    dc.cod_indicador_control_precio,
    dc.cod_categoria_valoracion,
    safe_cast(null as string) as cod_categoria_valoracion_recomendada,
    dc.cod_caracteristica_planificacion,
    case when cpl.cod_caracteristica_planificacion is null then false else true end as flg_caract_planificacion,
    dc.cod_clase_aprovisionamiento,
    dc.cod_planificacion_necesidad,
    dc.cod_grupo_compra,
    case when grpc.cod_grupo_compra is null then false else true end as flg_grupo_compras,
    dc.num_tiempo_entrega_previsto,
    dc.cod_almacen_aprovisionamiento_externo,
    dc.cod_almacen_produccion,
    dc.cod_grupo_importacion_exportacion,
    dc.cod_tipo_aprovisionamiento_especial,
    dc.cod_aprovisionamiento_especial,
    case
      when dc.cod_aprovisionamiento_especial is not null and dc.num_tiempo_entrega_previsto < 7 then true
      else false
    end as flg_tiempo_entrega,
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
    case 
      when TRIM(coalesce(val_prctr.cod_centro_beneficio,''))='' THEN NULL
      ELSE val_prctr.cod_centro_beneficio
    END as cod_centro_beneficio_propuesto,
    dc.cod_indicador_impuesto,
    dc.num_tiempo_trat_entrada_mercancia,
    dc.fec_creacion_material,
    case 
      when dc.cod_tipo_material in ('ZFER','ZHAW') and dc.fec_creacion_material > '2024-03-11' and ucdm.id_material is not null then 'UCDM'
      when dc.cod_tipo_material in ('ZLER','ZROH') and dc.fec_creacion_material > '2024-03-18' and ucdm.id_material is not null then 'UCDM'
      when dc.cod_tipo_material in ('ZERS','ZHIB','ZNLA') and dc.fec_creacion_material >= '2024-07-01' and ucdm.id_material is not null then 'UCDM'
      when dc.cod_tipo_material not in ('ZFER','ZHAW','ZLER','ZROH','ZERS','ZHIB','ZNLA') then null 
      else 'Planeamiento'
    end as des_equipo_creador,
    dc.cod_usuario_creador,
    dc.fec_ultima_modificacion,
    dc.cod_usuario_ultima_modificacion,
    dc.cod_determinacion_precio,
    cpr.flg_determinacion_precio as val_determinacion_precio_correcto,
    dc.cod_indicador_control_precios,
    cpr.num_indicador_control_precio as cod_indicador_control_precios_correcto,
    dc.val_precio_actual,
    dc.val_cantidad_base,
    dc.val_precio_anterior,
    case when dc.val_precio_anterior!=0 then abs(dc.val_precio_actual/dc.val_precio_anterior - 1) end as val_variacion_precio,
    case when dc.val_cantidad_base!=0 then round(dc.val_precio_actual/dc.val_cantidad_base, 4) end as val_ratio_precio_base,
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
    SAFE_CAST(NULL AS BOOLEAN) AS flg_componente, -- case when mc.cod_centro is null then true else false end,
    dc.flg_fert_hawa,
    dc.est_status_fert_hawa,
    -- case 
    --   when cu03.cod_material is not null then true
    --   else false 
    -- end as flg_racio_cu03,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_racio_cu03,
    dc.des_negocio,
    dc.des_subnegocio,
    cb.val_centro_beneficio_digito as cod_centro_beneficio_digito_567,
    case
      when dc.cod_caracteristica_planificacion in('YD') and dc.num_tiempo_entrega_previsto>4 then false
      when dc.cod_caracteristica_planificacion in('ZD') and dc.num_tiempo_entrega_previsto<=4 then false
      else true
    end as flg_tipo_mrp,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_tipo_mrp_2,
    -- case
    --   when dc.cod_tipo_material = 'ZLER'
    --     and dc.cod_material = mla.cod_material_componente
    --     and mla.cod_caracteristica_planificacion NOT IN ('ND','XA')
    --     and dc.cod_centro=mla.cod_centro
    --     and des_lista_materiales like '%ZFER%' then true
    --   when dc.cod_tipo_material = 'ZROH'
    --     and dc.cod_material = mla.cod_material_componente
    --     and mla.cod_caracteristica_planificacion NOT IN ('ND','XA')
    --     and dc.cod_centro=mla.cod_centro
    --     and des_lista_materiales like '%ZFER%' then true
    --   else false
    -- end as flg_tipo_mrp_2,
    dc.cnt_stock_seguridad,
    dc.cnt_lote_minimo,
    dc.num_valor_redondeo,
    dc.flg_suspension,
    dc.cod_material_reemplazo as cod_material_reemplazo,
    dc.cod_material_funcional,
    case
      when substring(dc.cod_grupo_tratamiento_logistico,4,1) in ('6')
        and num_tiempo_entrega_previsto<=60 then true
      when substring(dc.cod_grupo_tratamiento_logistico,4,1) in ('7')
        and num_tiempo_entrega_previsto<=30 then true
      else false
    end as flg_leadtime,
    -- case 
    --   when ra.id_material is not null then true 
    --   else false 
    -- end as flg_receta,
    -- ra.cod_grupo_receta,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_receta,
    SAFE_CAST(NULL AS STRING) AS cod_grupo_receta,
    SAFE_CAST(NULL AS STRING) AS des_lista_materiales, -- mla.des_lista_materiales,
    dc.cod_bloqueo_centro,
    case
      when (substring(dc.cod_grupo_tratamiento_logistico,4,1) in('1','2','3','4','5','6') and dc.cod_tipo_material='ZLER') 
        or (substring(dc.cod_grupo_tratamiento_logistico,4,1) in ('1','2','3','4','5','7') and dc.cod_tipo_material='ZROH') then true
      else false
    end as flg_grp_trat_log,
    dc.cod_material_reemplazante,
    dc.flg_codigo_material_reemplazante,
    case
      when dc.cod_centro in ('1007','1011','1012','1014','1015','1016','1023','1024','1500','1501','1502','1503','1504','1505','1506','1507','1602','1603','1605','1606') then true
      else false
    end as flg_centro_ibp,
    dc.flg_excepcion_graneles,
    dc.des_planificacion_necesidad,
    case
      when (dc.cod_grupo_compra in ('324','312') and cod_clase_aprovisionamiento='F'
        and cod_aprovisionamiento_especial is null)
        OR (dc.cod_grupo_compra not in ('324','312') and cod_aprovisionamiento_especial!='30' and cod_aprovisionamiento_especial is null) then false
      else true
    end as flg_aprov,
    case 
      when num_tiempo_entrega_previsto <=15 and dc.cod_caracteristica_planificacion='ZD' and dc.cod_grupo_tratamiento_logistico='0002' then true
      when num_tiempo_entrega_previsto >=15 and dc.cod_caracteristica_planificacion='YD' and dc.cod_grupo_tratamiento_logistico='0002' then true
      else false
    end as flg_leadtime_mrp,
    case
      when dc.flg_pedido_automatico is null then false
      else dc.flg_pedido_automatico
    end as flg_pedido_automatico,
    dc.flg_disponibilidad, 
    dc.cod_tamanio_lote as cod_dimension_lote,
    SAFE_CAST(NULL AS STRING) AS cod_nuevo_estado_material, -- fh.flg_status_nuevo,
    mrc.cod_caracteristicas_concatenadas,
    dc.cod_planner as des_informacion_fabricacion,
    dc.cod_valor_compra,
    -- case 
    --   when vfab.id_material is not null then true
    --   else false
    -- end as flg_version_fabricacion,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_version_fabricacion,
    -- case 
    --   when vfab2.id_material is not null then true
    --   else false
    -- end as flg_version_fabricacion_centro,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_version_fabricacion_centro,
    -- case
    --   when vfab3.id_material is not null then true
    --   else false
    -- end as flg_version_fabricacion_creado,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_version_fabricacion_creado,
    case 
      when mmq.id_material is not null then true
      else false
    end as flg_material_maquila,
    case 
      when dc.cod_tipo_material in ('ZFER','ZHAW') and mca.cod_material is not null then true
      when dc.cod_tipo_material in ('ZHAL') and mcaz.cod_material is not null then true
      else false
    end as flg_material_centro_ampliado,
    case 
      when mfc.id_material is not null then true
      else false
    end as flg_material_maquila_completa,
    -- case
    --   when czhal.cod_material is not null then true
    --   else false
    -- end as flg_componente_zhal,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_componente_zhal,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_componente_zroh_zler,
    -- case
    --   when cro.cod_material is not null then true
    --   else false
    -- end as flg_componente_zroh_zler,
    dc.num_tiempo_duracion,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_lista_activa,
    -- case
    --   when lza.cod_material is not null then TRUE
    --   else FALSE
    -- end as flg_lista_activa,
    mcs.cnt_stock,
    dc.mnt_precio_plan,
    dc.val_fecha_plan,
    SAFE_CAST(NULL AS DATE) AS fec_inicio_extrema_maxima, -- bfi.fec_inicio_extrema_maxima,
    case 
      when rm.cod_material is not null then rm.des_responsable
      when rm.cod_material is null and dc.des_categoria in ('Detergentes','Detergentes Maquila') and left(dc.cod_centro,2) = '10' then 'Sandra Flores'
      when rm.cod_material is null and dc.des_categoria in ('Detergentes','Detergentes Maquila') and left(dc.cod_centro,2) = '15' then 'Juan Teran' 
      when rm.cod_material is null and dc.des_categoria not in ('Detergentes','Detergentes Maquila') then coalesce(cr.des_responsable, 'Sin responsable')
    end as des_responsable_material_centro,
    'Hadjie Tarazona' as des_responsable_material_indirecto,
    case
      when dc.des_categoria in ('Detergentes','Detergentes Maquila') and left(dc.cod_centro,2) = '10' then 'Karen Arzani'
      when dc.des_categoria in ('Detergentes','Detergentes Maquila') and left(dc.cod_centro,2) = '15' then 'Valeria Suazo'
      when dc.des_categoria in ('Harinas','Harinas Maquila') and dc.cod_centro in ('1007','1023') then 'Javier Pairazaman'
      when dc.des_categoria in ('Harinas','Harinas Maquila') and dc.cod_centro in ('1015') then 'Andres Bautista'
      when dc.des_categoria in ('Harinas','Harinas Maquila') and dc.cod_centro in ('1016') then 'Javier Pairazaman'
      when rcp.des_categoria is null then 'Sin responsable'
      else rcp.des_responsable
    end as des_responsable_categoria_produccion, 
    case  
      when dc.cod_plataforma in ('10') then 'Angela Rodriguez'
      when dc.cod_plataforma in ('20','50') then 'Scarlet Flores'
      when coalesce(dc.cod_plataforma,'') not in ('10','20','50') THEN rcp.nom_des_responsable_ip
      else 'Sin Responsable'
    end as des_responsable_clasificacion, 
    case
      -- when fh.ind_exportacion = 'E' then 'David'
      when crd.des_categoria = 'Harinas' and dc.cod_centro = '1015' then 'Alexander' 
      when crd.des_categoria is null then 'Sin responsable'
      else crd.des_responsable 
    end as des_responsable_distribucion
  from datos_centro dc
  left join `{silver_project_id}.slv_gobierno.ptp_categoria_responsable_distribucion` crd 
    on UPPER(crd.des_categoria) = UPPER(dc.des_categoria)
  left join responsable_categoria_pprod rcp 
    on UPPER(rcp.des_categoria) = UPPER(dc.des_categoria)
  left join responsables_material_centro rm 
    on rm.cod_material = dc.cod_material
    and rm.cod_centro = dc.cod_centro
    and val_ranking = 1
  left join `{silver_project_id}.slv_gobierno.ptp_categoria_responsable` cr 
    on UPPER(cr.des_categoria) = UPPER(dc.des_categoria)

--  left join base_fecha_inicio bfi 
--    on dc.id_material = concat('MAT-DE-WILSON-',bfi.cod_material)

--  left join `{silver_project_id}.slv_modelo_maestro.horizonte_centros` mac 
--    on dc.cod_centro = mac.cod_centro

  left join materiales_cantidad_stock mcs
    on dc.id_material = mcs.id_material
    and dc.cod_centro = mcs.cod_centro

--  left join listas_zhal_activas lza
--    on lza.cod_material = dc.cod_material
--    and lza.cod_centro = dc.cod_centro

  -- left join componentes_zhal_listas_ferhal czhal
  --   on czhal.cod_material = dc.cod_material
  --   and dc.cod_centro = czhal.cod_centro

--  left join componentes_en_lm_activas_v2 cro
--    on cro.cod_material = dc.cod_material

  left join maquilas_full_cost mfc
    on mfc.id_material = dc.id_material
  left join materiales_maquila mmq
    on dc.id_material = mmq.id_material
  left join material_centro_ampliado_zfer mca
    on dc.cod_material = mca.cod_material
    and dc.cod_centro_origen = mca.cod_centro
  left join material_centro_ampliado_zhal mcaz
    on dc.cod_material = mcaz.cod_material
    and dc.cod_centro_origen = mcaz.cod_centro
  left join material_mrp_concatenado mrc
    on dc.cod_material = mrc.cod_material

--  left join base_fert_hawa fh
--    on REGEXP_REPLACE(dc.cod_material, '^0+', '') = REGEXP_REPLACE(fh.cod_material, '^0+', '')

  -- left join base_version_fabricacion vfab
  --   on vfab.id_material = dc.id_material
  --   and vfab.flg_bloqueo is null
  --   and vfab.fec_fin_validez > current_date()
  -- left join base_version_fabricacion vfab2
  --   on vfab2.id_material = dc.id_material
  --   and vfab2.cod_centro = dc.cod_centro
  --   and vfab2.flg_bloqueo is null
  --   and vfab2.fec_fin_validez > current_date()
  -- left join base_version_fabricacion vfab3
  --   on vfab3.id_material = dc.id_material

  left join `{silver_project_id}.slv_gobierno.ptp_material_grupo_compra` grpc
    on dc.cod_tipo_material=grpc.cod_tipo_material 
    and dc.cod_grupo_compra=grpc.cod_grupo_compra
    and dc.cod_grupo_articulo_3=grpc.cod_grupo_articulo
  left join `{silver_project_id}.slv_gobierno.ptp_material_caracteristica_planificacion` cpl
    on dc.cod_tipo_material = cpl.cod_tipo_material 
    and coalesce(dc.flg_compra_2,'')= coalesce(cpl.flg_compra,'') 
    and dc.cod_caracteristica_planificacion=cpl.cod_caracteristica_planificacion
  left join `{silver_project_id}.slv_gobierno.ptp_homologacion_jerarquia_centro_beneficio` val_prctr
    on dc.cod_tipo_material in ('ZFER','ZHAW') 
    and left(dc.cod_jerarquia,7)=val_prctr.cod_categoria 
    and dc.cod_negocio = val_prctr.cod_negocio 
    and dc.cod_subnegocio= val_prctr.cod_subnegocio
  left join `{silver_project_id}.slv_gobierno.rtr_costo_control_precio` cpr
    on dc.cod_tipo_material=cpr.cod_tipo_material
    and dc.cod_categoria_valoracion=cpr.cod_categoria_valoracion

--  left join componentes_lmt_activas mla
--    on dc.cod_material = mla.cod_material_componente

--  left join materiales_componentes mc
--    on dc.id_material=mc.id_material
--    and dc.cod_centro = mc.cod_centro

  left join materiales_stock ms
    on dc.id_material=ms.id_material
    and dc.cod_centro = ms.cod_centro
  -- left join materiales_racio_cu03 cu03
  --   on dc.cod_material=cu03.cod_material
    -- and dc.cod_centro = cu03.cod_centro
  -- left join recetas_activas ra
  --   on dc.id_material=ra.id_material
    -- and dc.cod_centro=ra.cod_centro
  left join `{silver_project_id}.slv_gobierno.ptp_material_grupo_produccion_centro_beneficio` cb
    on dc.cod_negocio=cb.cod_negocio
  left join materiales_ucdm ucdm
    on dc.id_material=ucdm.id_material
  -- where dc.cod_sociedad<>'PE13'
)
select
  'DE-WILSON' des_origen,
  row_number()over(order by cod_material, cod_centro) as val_rownum,
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
  des_centro,
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
  flg_tiempo_entrega,
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
  flg_tipo_mrp_2,
  cnt_stock_seguridad,
  cnt_lote_minimo,
  num_valor_redondeo,
  flg_suspension,
  cod_material_reemplazo,
  cod_material_funcional,
  flg_leadtime,
  flg_receta,
  cod_grupo_receta,
  des_lista_materiales,
  cod_bloqueo_centro,
  flg_grp_trat_log,
  cod_material_reemplazante,
  flg_codigo_material_reemplazante,
  flg_centro_ibp,
  flg_excepcion_graneles,
  des_planificacion_necesidad,
  flg_aprov,
  flg_leadtime_mrp,
  flg_pedido_automatico,
  flg_disponibilidad,
  cod_dimension_lote,
  cod_nuevo_estado_material,
  cod_caracteristicas_concatenadas,
  des_informacion_fabricacion,
  cod_valor_compra,
  flg_version_fabricacion,
  flg_version_fabricacion_centro,
  flg_version_fabricacion_creado,
  flg_material_maquila,
  flg_material_centro_ampliado,
  flg_material_maquila_completa,
  flg_componente_zhal,
  flg_componente_zroh_zler,
  num_tiempo_duracion,
  flg_lista_activa,
  cnt_stock,
  mnt_precio_plan,
  val_fecha_plan,
  fec_inicio_extrema_maxima,
  des_responsable_material_centro,
  des_responsable_material_indirecto,
  des_responsable_categoria_produccion,
  des_responsable_clasificacion,
  des_responsable_distribucion,
  cod_material || coalesce(cod_centro,'') as val_dbkey,
  current_datetime('America/Lima') as fec_proceso
from base_final
-- where cod_centro != 'D999'
;

merge into `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion` t
using (
  select 
    cod_tipo_material,
    cod_centro_beneficio
  from `{silver_project_id}.slv_gobierno.ptp_material_homologacion_tipo_material`
  where cod_tipo_material in ('ZHIB','ZUNB','ZLEI','ZERS')
) s
on (
  t.cod_tipo_material=s.cod_tipo_material
  and t.cod_centro_beneficio=s.cod_centro_beneficio
)
when matched then
update set 
  t.cod_centro_beneficio_propuesto=s.cod_centro_beneficio;

merge into `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion` t
using (
  select 
    cod_tipo_material,
    cod_grupo_articulo,
    cod_categoria_valoracion
  from `{silver_project_id}.slv_gobierno.ptp_material_categoria_valoracion`
  where cod_tipo_material in ('ZROH','ZWER','ZLER','ZLEI','ZHIB','ZERS','ZHAW')
) s
on (
  t.cod_tipo_material=s.cod_tipo_material
  and t.est_grupo_articulo_3=s.cod_grupo_articulo
)
when matched then
update set 
  t.cod_categoria_valoracion_recomendada=s.cod_categoria_valoracion;

update `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
set cod_categoria_valoracion_recomendada = cod_categoria_valoracion
where cod_tipo_material='ZROH'
and est_grupo_articulo_3='X'
and cod_categoria_valoracion = '3002'
and cod_categoria_valoracion_recomendada = '3004';

merge into `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion` t
using (
  select 
    cod_tipo_material,
    cod_grupo_articulo,
    cod_categoria_valoracion
  from `{silver_project_id}.slv_gobierno.ptp_material_categoria_valoracion_no_almacen`
  where cod_tipo_material in ('ZNLA')
) s
on (
  t.cod_tipo_material=s.cod_tipo_material
  and left(t.cod_grupo_articulo,3)=s.cod_grupo_articulo
)
when matched then
update set 
  t.cod_categoria_valoracion_recomendada=s.cod_categoria_valoracion;

update `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
set cod_categoria_valoracion_recomendada='7900'
where cod_tipo_material='ZHAL'
and cod_material in (
  select distinct cod_material
  from `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
  where cod_tipo_material='ZHAL'
  and (
    cod_clase_aprovisionamiento in ('E','X')
    or (cod_clase_aprovisionamiento='F' and cod_aprovisionamiento_especial='30')
  )
);

update `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
set cod_categoria_valoracion_recomendada='7920'
where cod_tipo_material='ZFER'
and cod_material in (
  select distinct cod_material
  from `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
  where cod_tipo_material='ZFER'
  and cod_clase_aprovisionamiento='E'
  and cod_aprovisionamiento_especial is null
);

update `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
set cod_categoria_valoracion_recomendada='7921'
where cod_tipo_material='ZFER' 
and cod_planificacion_necesidad='TER'
and (
  (cod_aprovisionamiento_especial is null and cod_clase_aprovisionamiento='F')
  or cod_aprovisionamiento_especial='30'
)
and cod_categoria_valoracion_recomendada is null;

update `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
set cod_categoria_valoracion_recomendada = CASE 
  WHEN cod_tipo_material = 'ZFER' THEN '3006'
  WHEN cod_tipo_material = 'ZHAL' THEN '3007'
END
where cod_tipo_material in ('ZFER','ZHAL') 
and cod_sociedad_origen is not null
and cod_centro != cod_centro_origen
and cod_caracteristica_planificacion in ('YD','ZD');

update `{horizonte_project_id}.hzt_planeamiento.horizonte_material_centro_valoracion`
set cod_categoria_valoracion_recomendada='0'
where cod_categoria_valoracion_recomendada is null;