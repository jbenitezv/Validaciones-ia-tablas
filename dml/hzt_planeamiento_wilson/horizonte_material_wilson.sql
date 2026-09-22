/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_MATERIAL.
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from `{horizonte_project_id}.hzt_planeamiento.horizonte_material`
where des_origen = 'DE-WILSON';

insert into `{horizonte_project_id}.hzt_planeamiento.horizonte_material`
with
materia_prima as (
  select distinct 
    id_material 
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  -- where cod_grupo_compra in ('007', '008')
  -- and coalesce(cod_bloqueo_centro,'') != '03'
)
-- , materiales_con_lmt as (
--   select 
--     id_material,
--     string_agg(cod_centro, ',') as cod_centros_lmt
--   from `{horizonte_project_id}.hzt_planeamiento.horizonte_lista_material_cabecera`
--   group by id_material
-- )
, materiales_kg as (
  select
    id_material, 
    num_numerador_conversion as num_denominador_kg, 
    num_denominador_conversion as num_numerador_kg,
  from `{silver_project_id}.slv_modelo_material.horizonte_material_unidad_medida`
  where cod_unidad_medida = 'KG'
)
, materiales_uco as (
  select distinct id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_unidad_medida`
  where cod_unidad_medida = 'UCO'
)
, grp_articulo_propuesto as (
  SELECT 
    cod_tipo_material, 
    flg_materia_prima,
    string_agg(cod_grupo_articulo, ',') as cod_grupo_articulo_propuesto
  FROM `{silver_project_id}.slv_gobierno.ptp_grupo_articulo`
  GROUP BY cod_tipo_material, flg_materia_prima
)
, material_funcional as (
  select cod_material_funcional, id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_aux`
)
, materiales_centro as (
  select distinct id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  where coalesce(cod_bloqueo_centro, '') != '03'
  and cod_centro !='D999'
  and cod_sociedad in ('PE11','PE21','PE14','PE16')
)
, materiales_orgventa_raw as (
  select 
    id_material,
    cod_negocio,
    des_negocio as des_grupo_materiales1,
    cod_subnegocio,
    des_subnegocio as des_grupo_materiales2,
    cod_marca,
    des_marca as des_grupo_materiales4,
    cod_bloqueo_comercial,
    row_number()over(partition by id_material order by cod_bloqueo_comercial, cod_organizacion_venta) as val_rnn
  from `{silver_project_id}.slv_modelo_material.horizonte_material_organizacion_venta`
  where cod_sociedad in ('PE11','PE21','PE14','PE16')
)
-- , materiales_racio_cu03 as (
--   select distinct cod_material
--   from (
--     select cod_material_padre as cod_material
--     from `alicorp-datalake.delivery_supply.materiales_alcance_producto_terminado`
--       union all
--     select safe_cast(cod_material_componente as STRING) as cod_material
--     from `alicorp-datalake.delivery_supply.materiales_alcance_producto_terminado`
--   )
-- )
, materiales_orgventa as (
  select
    id_material,
    cod_negocio,
    des_grupo_materiales1,
    cod_subnegocio,
    des_grupo_materiales2,
    cod_marca,
    des_grupo_materiales4,
    cod_bloqueo_comercial,
    val_rnn
  from materiales_orgventa_raw
  where val_rnn = 1
)
, materiales_dummy as (
  select distinct id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  where coalesce(cod_bloqueo_centro,'') != '03'
  and cod_centro != 'D999'
  and cod_tipo_material = 'ZHAL'
  and cod_aprovisionamiento_especial = '50'
)
, materiales_stock as 
(
  select distinct id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_almacen`
  where cnt_stock_libre_utilizacion + cnt_stock_lotes_restringidos + cnt_stock_en_traslado + cnt_stock_bloqueado + cnt_stock_en_inspeccion_calidad + cnt_stock_en_devoluciones > 0 
)
, materiales_cantidad_stock as 
(
  select distinct 
    id_material,
    SUM(cnt_stock_libre_utilizacion + cnt_stock_lotes_restringidos + cnt_stock_en_traslado + cnt_stock_bloqueado + cnt_stock_en_inspeccion_calidad + cnt_stock_en_devoluciones) as cnt_stock
  from `{silver_project_id}.slv_modelo_material.horizonte_material_almacen`
    group by 1
)
, materiales_alicorp as (
  select distinct id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_organizacion_venta`
  where cod_sociedad = 'PE11'
  and coalesce(cod_bloqueo_comercial, '') != '01'
)
, materiales_ali_itdvc as (
  select distinct id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  where cod_sociedad in ('PE11', 'PE21')
  and coalesce(cod_bloqueo_centro, '') != '03'
) 
-- , ultima_foto as (
--   select max(fec_proceso) as fec_fecha
--   from `{horizonte_project_id}.hzt_planeamiento.horizonte_material_historico`
--   where fec_proceso < current_date
-- )
-- , materiales_tiempo_historico as (
--   select 
--     ht.cod_material,
--     ht.cod_tipo_material,
--     ht.num_tiempo_vida_anterior,
--     ht.cod_unidad_tiempo,
--     ht.fec_proceso
--   from `{horizonte_project_id}.hzt_planeamiento.horizonte_material_historico` ht
--   join ultima_foto fot
--     on ht.fec_proceso=fot.fec_fecha
-- )
, factor_paleta as (
  select 
    id_material,
    num_numerador_conversion as num_numerador_conversion_paleta,
    num_denominador_conversion as num_denominador_conversion_paleta
  from `{silver_project_id}.slv_modelo_material.horizonte_material_unidad_medida`
  where cod_unidad_medida = 'PAL'
)
-- , fh_status as (
--   select distinct
--     'MAT-DE-WILSON-' || case 
--       when safe_cast(cod_material as NUMERIC) is null then cod_material
--       else right(repeat('0', 18) || cod_material, 18)
--     end as id_material,
--     safe_cast(null as string) as status,
--     est_nuevo_material as flg_status_nuevo,
--     cod_unidad_base, 
--     ind_exportacion
--   from `{golden_project_id}.gld_inventario.s4_material_fert_hawa`
-- )
, exclusion_material_zhal as (
select 
id_material
from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
where cod_categoria_valoracion in ('7905','7906')
group by 1
)
,materiales_alicorp_centro as (
  select distinct id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  -- where left(cod_centro,2) in ('10','15','16')
)
, datos_material as (
  select distinct
    mb.id_material,
    mb.id_material_origen as cod_material,
    mbd.cod_material_funcional as cod_material_interfaz,
    mb.des_material as des_material,
    mb.cod_tipo_material,
    mb.cod_jerarquia_material,
    case 
        when trim(substring(mb.cod_jerarquia_material,5,3)) = '' then null
        else substring(mb.cod_jerarquia_material,5,3)
    end as cod_categoria_producto,
    length(mb.cod_jerarquia_material) as num_long_cod_jerarquia,
    SAFE_CAST(NULL AS STRING) AS cod_plataforma, -- mj.cod_plataforma,
    SAFE_CAST(NULL AS STRING) AS des_plataforma, -- mj.des_plataforma as des_plataforma,
    SAFE_CAST(NULL AS STRING) AS cod_sub_plataforma, -- mj.cod_sub_plataforma,
    SAFE_CAST(NULL AS STRING) AS des_subplataforma, -- mj.des_sub_plataforma as des_subplataforma,
    SAFE_CAST(NULL AS STRING) AS cod_categoria, -- mj.cod_categoria,
    SAFE_CAST(NULL AS STRING) AS des_categoria, -- mj.des_categoria as des_categoria,
    SAFE_CAST(NULL AS STRING) AS cod_familia, -- mj.cod_familia,
    SAFE_CAST(NULL AS STRING) AS des_familia, -- mj.des_familia as des_familia,
    SAFE_CAST(NULL AS STRING) AS cod_variedad, -- mj.cod_variedad,
    SAFE_CAST(NULL AS STRING) AS des_variedad, -- mj.des_variedad as des_variedad,
    SAFE_CAST(NULL AS STRING) AS cod_presentacion, -- mj.cod_presentacion,
    SAFE_CAST(NULL AS STRING) AS des_presentacion, -- mj.des_presentacion as des_presentacion,
    case when mp.id_material is null then FALSE else TRUE end as flg_materia_prima,
    case when mp.id_material is null then FALSE else TRUE end as flg_materia_prima_2,
    case when md.id_material is null then FALSE else TRUE end as flg_dummy,
    mb.cod_grupo_material,
    mb.des_grupo_material,
    left(mb.cod_grupo_material, 1) as cod_grupo_articulo_2,
    case left(mb.cod_grupo_material,1) when 'C' then 'C' else 'X' end as cod_grupo_articulo_3,
    left(mbd.des_duenio_marca,4) as cod_sociedad,
    case when mc.id_material is null then FALSE else TRUE end as flg_centro,
    case when mo.id_material is null then FALSE else TRUE end as flg_organizacion_venta,
    mb.cod_unidad_medida_base as cod_unidad_base,
    mbd.cod_bloqueo,
    mbd.cod_grupo_transporte,
    mbd.des_grupo_transporte as des_grupo_transporte,
    safe_cast(mbd.num_duracion_total as INT64) as num_tiempo_vida, 
    safe_cast(mbd.num_tiempo_duracion as INT64) as num_tiempo_duracion,
    mbd.cod_unidad_tiempo as cod_unidad_tiempo_vida,
    mbd.est_actualizacion as est_status_actualizacion,
    mbd.est_actualizacion_completa as est_status_actualizacion_completa,
    mbd.cod_duenio_marca,
    mbd.des_duenio_marca as des_fabricante,
    mbd.cod_onu_cubso,
    mbd.cod_unidad_tiempo,
    mb.num_peso_bruto as mnt_peso_bruto_unidad_base,
    mb.num_peso_neto as mnt_peso_neto_unidad_base,
    mb.cod_unidad_peso as cod_unidad_peso_base,
    safe_cast(round(
      case mb.cod_unidad_peso
        when 'TO' then 1000
        when 'G' then 0.001
        else 1 
      end * mb.num_peso_bruto, 3) as NUMERIC) as mnt_peso_bruto_kg,
    safe_cast(round(
      case mb.cod_unidad_peso
        when 'TO' then 1000
        when 'G' then 0.001
        else 1 
      end * mb.num_peso_neto, 3) as NUMERIC) as mnt_peso_neto_kg,
    marm.num_numerador_kg,
    marm.num_denominador_kg,
    case when marm.id_material is null then FALSE else TRUE end as flg_conversion_kg,            
    safe_cast(round(marm.num_numerador_kg / marm.num_denominador_kg, 3) as NUMERIC) as mnt_peso_convertido_kg,
    case when mu.id_material is null then FALSE else TRUE end as flg_unidad_comercial,
    mbd.cod_unidad_comercial as cod_unidad_comercial_material,
    mbd.num_peso_bruto_comercial as mnt_peso_bruto_unidad_comercial,
    mbd.cod_unidad_peso_comercial as cod_unidad_peso_comercial,
    safe_cast(round(
      case mbd.cod_unidad_peso_comercial
        when 'TO' then 1000
        when 'G' then 0.001
        else 1 
      end * mbd.num_peso_bruto_comercial, 3) as NUMERIC) as mnt_peso_unidad_comercial_kg,
    mbd.num_numerador_conversion_unidad_comercial as num_numerador_conversion_uco,
    mbd.num_denominador_conversion_unidad_comercial as num_denominador_conversion_uco,
    safe_cast(round(
      case mbd.cod_unidad_peso_comercial when 'TO' then 1000 when 'G' then 0.001 else 1 end * 
        mbd.num_peso_bruto_comercial * mbd.num_denominador_conversion_unidad_comercial/
          mbd.num_numerador_conversion_unidad_comercial,
      3) as NUMERIC) as mnt_peso_bruto_unidad_base_calculado,
    mbd.cod_planner,
    mbd.flg_sujeto_a_lote,
    mb.fec_creacion as fec_creacion_material,
    mbd.cod_usuario_creador,
    mb.fec_modificacion as fec_ultima_modificacion,
    mbd.cod_usuario_ultima_modificacion,
    case when al.id_material is not null then TRUE else FALSE  end as flg_alicorp,
    case when mai.id_material is not null then TRUE else FALSE end as flg_ali_itdvco,
    SAFE_CAST(NULL AS INT64) AS num_tiempo_vida_anterior, -- mth.num_tiempo_vida_anterior,
    SAFE_CAST(NULL AS STRING) AS cod_unidad_tiempo_vida_ant, -- mth.cod_unidad_tiempo,
    SAFE_CAST(NULL AS DATE) AS fec_tiempo_vida_ant, -- safe_cast(mth.fec_proceso as date),
    SAFE_CAST(NULL AS BOOLEAN) AS flg_tiempo_vida, -- case when mth.num_tiempo_vida_anterior =mbd.num_duracion_total then TRUE else FALSE end,
    mbd.cod_bloqueo_venta,
    mo.cod_negocio,
    mo.des_grupo_materiales1,
    mo.cod_subnegocio,
    mo.des_grupo_materiales2,
    mo.cod_marca,
    mo.des_grupo_materiales4,
    mbd.cod_unidad_almacenamiento as cod_unidad_almacenamiento,
    mbd.num_numerador_conversion_unidad_almacenamiento as num_numerador_conv_unidad_almacenamiento,
    mbd.num_denominador_conversion_unidad_almacenamiento as num_denominador_conv_unidad_almacenamiento,
    mbd.num_peso_bruto_almacenamiento as mnt_peso_bruto_almacenamiento,
    mb.num_peso_neto*mbd.num_numerador_conversion_unidad_almacenamiento/
    mbd.num_denominador_conversion_unidad_almacenamiento as mnt_peso_neto_almacenamiento,
    pal.num_numerador_conversion_paleta,
    pal.num_denominador_conversion_paleta,
    mb.num_peso_neto*pal.num_numerador_conversion_paleta/
    pal.num_denominador_conversion_paleta as mnt_peso_neto_paleta,
    mb.num_volumen as mnt_volumen_unidad_base,
    mb.cod_unidad_volumen as cod_unidad_volumen_base,
    mbd.cod_material_reemplazo,
    mbd2.cod_material_reemplazo as cod_material_reemplazo_recursivo,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_lmt, -- case when lmt.id_material is not null then TRUE else FALSE end flg_lmt,
    SAFE_CAST(NULL AS STRING) AS cod_centros_lmt, -- lmt.cod_centros_lmt,
    mo.cod_bloqueo_comercial,
    mbd.cod_grupo_tipo_posicion_general,
    mb.cod_ramo,
    mbd.cod_condicion_almacenaje, 
    SAFE_CAST(NULL AS STRING) AS des_responsable_material -- coalesce(cr.des_responsable, 'Sin responsable') as des_responsable_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material` mb
  inner join materiales_alicorp_centro mal
    on mal.id_material = mb.id_material
  inner join `{silver_project_id}.slv_modelo_material.horizonte_material_aux` mbd
  on mb.id_material = mbd.id_material
  left join `{silver_project_id}.slv_modelo_material.horizonte_material_aux` mbd2
  on concat('MAT-DE-WILSON-',mbd.cod_material_reemplazo) = mbd2.id_material
  left join materia_prima mp
    on mb.id_material = mp.id_material
  left join materiales_kg marm
    on mb.id_material = marm.id_material
--  left join `{silver_project_id}.slv_modelo_material.horizonte_material_jerarquia` mj
--    on mb.cod_jerarquia_material = mj.cod_jerarquia_material
--  left join `{silver_project_id}.slv_gobierno.ptp_categoria_responsable` cr 
--    on UPPER(cr.des_categoria) = UPPER(mj.des_categoria)
  left join materiales_centro mc
    on mb.id_material=mc.id_material
  left join materiales_dummy md
    on mb.id_material=md.id_material
  left join materiales_uco mu
    on mb.id_material=mu.id_material
  left join materiales_orgventa mo
    on mb.id_material=mo.id_material
  left join materiales_alicorp al
    on mb.id_material=al.id_material
  left join materiales_ali_itdvc mai
    on mb.id_material=mai.id_material
--  left join materiales_tiempo_historico mth
--    on mbd.cod_material_funcional=mth.cod_material
  left join factor_paleta pal
    on mb.id_material=pal.id_material 
--  left join materiales_con_lmt lmt
--    on mb.id_material = lmt.id_material
  where mb.des_origen = 'DE-WILSON'
  --and coalesce(mbd.cod_bloqueo,'') != '03'
)
, zfer_zhaw_activos as (
  select distinct
    id_material 
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  -- where (cod_tipo_material = 'ZFER' and cod_caracteristica_planificacion in ('ZM','YD','XD')) OR (cod_tipo_material = 'ZHAW' and cod_caracteristica_planificacion = 'XD')
)
, materiales_ucdm as (
  select distinct 
    id_material
  from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
  -- where cod_sociedad in ('CO11', 'EC11', 'PE11', 'PE14', 'PE18', 'PE21')
)
-- , material_clase_001 as (
--   select distinct
--     id_material
--   from `{silver_project_id}.slv_modelo_material.horizonte_material_clase`
--   -- where cod_clase = '001'
-- )
-- , material_clase_023 as (
--   select distinct
--     id_material
--   from `{silver_project_id}.slv_modelo_material.horizonte_material_clase`
--   -- where cod_clase = '023'
-- )
-- , base_consumo_201_261 as (
--   SELECT id_material, fec_movimiento, rank() over (partition by id_material order by fec_movimiento desc) as val_ranking 
--   from `{silver_project_id}.slv_modelo_material.horizonte_movimiento_detalle`
--   WHERE PERIODO > '2023-01-01'
--   and cod_clase_movimiento in ('201','261')
-- )
-- , base_consumo_101 as (
--   SELECT id_material, fec_movimiento, rank() over (partition by id_material order by fec_movimiento desc) as val_ranking 
--   from `{silver_project_id}.slv_modelo_material.horizonte_movimiento_detalle`
--   WHERE PERIODO > '2023-01-01'
--   and cod_clase_movimiento in ('101')
-- )
-- , base_contratos as (
--   select a.id_material, max(dc.fec_fin_validez_documento) as fec_fin_validez_documento
--   from `{silver_project_id}.slv_modelo_compra.horizonte_documento_detalle` a
--   left join `{silver_project_id}.slv_modelo_compra.horizonte_documento_cabecera` dc 
--     on dc.id_documento = a.id_documento and dc.periodo is not null
--   where a.periodo is not null
--   and fec_fin_validez_documento >= current_date()
--   and des_categoria_documento_compra = 'Contrato'
--   group by 1
-- )
, base_final as (
  select distinct
    dm.id_material,
    dm.cod_material_interfaz as cod_material,
    dm.des_denominacion_material,
    dm.cod_tipo_material,
    dm.cod_jerarquia_material as cod_jerarquia,
    dm.cod_plataforma,
    dm.des_plataforma as des_plataforma,
    dm.cod_sub_plataforma as cod_subplataforma,
    dm.des_subplataforma as des_subplataforma,
    dm.cod_categoria,
    dm.des_categoria as des_categoria,
    dm.cod_familia,
    dm.des_familia as des_familia,
    dm.cod_variedad,
    dm.des_variedad as des_variedad,
    dm.cod_presentacion,
    dm.des_presentacion as des_presentacion,
    dm.cod_categoria_producto as cod_categoria_producto,
    case
      when 
        ((dm.des_denominacion_material like '%ACEIT%' and dm.des_denominacion_material like '%BLD%') or 
         (dm.des_denominacion_material like '%ACEIT%' and dm.des_denominacion_material like '%BIN%') or 
         (dm.des_denominacion_material like '%ACEIT%' and dm.des_denominacion_material like '%GRANEL%') or 
         (dm.des_denominacion_material like '%TBHQ%' or dm.des_denominacion_material like '%CISTERNA%') or 
         (dm.des_denominacion_material like '%HARIN%' and dm.des_denominacion_material like '%GRANEL%')) then TRUE
      else FALSE
    end flg_excepcion_material, 
    dm.num_long_cod_jerarquia as num_longitud_codigo_jerarquia,
    ljer.num_longitud_codigo_jerarquia as num_longitud_correcta_jerarquia,
    dm.flg_materia_prima_2 as flg_materia_prima,
    dm.flg_dummy as flg_dummy,
    dm.cod_material_interfaz,
    case 
      when length(dm.cod_material_interfaz) in (4,5,7) and dm.fec_creacion_material < '2021-03-01' then '1'
      when length(dm.cod_material_interfaz) in (7) and dm.fec_creacion_material >= '2021-03-01' then '2'
      else '3'
    end est_longitud_material,
    dm.cod_grupo_material,
    dm.des_grupo_material,
    case when gart.cod_grupo_articulo is null then FALSE else TRUE end flg_grupo_articulo,
    gart_prop.cod_grupo_articulo_propuesto as cod_grupo_articulo_propuesto,
    dm.cod_grupo_articulo_2 as cod_grupo_articulo_2,
    dm.cod_grupo_articulo_3 as cod_grupo_articulo_3,
    dm.cod_sociedad,
    dm.flg_centro as flg_centro,
    dm.flg_organizacion_venta as flg_organizacion_venta,
    dm.cod_unidad_medida_base as cod_unidad_base,
    dm.cod_bloqueo,
    dm.cod_grupo_transporte,
    dm.des_grupo_transporte as des_grupo_transporte,
    dm.num_tiempo_vida as num_tiempo_vida, 
    dm.num_tiempo_duracion as num_tiempo_duracion,
    dm.cod_unidad_tiempo_vida as cod_unidad_tiempo_vida,
    dm.est_status_actualizacion as est_actualizacion,
    dm.est_status_actualizacion_completa as est_actualizacion_completa,
    dm.cod_duenio_marca,
    dm.des_fabricante as des_duenio_marca,
    dm.cod_onu_cubso,
    dm.cod_unidad_tiempo,
    dm.mnt_peso_bruto_unidad_base as num_peso_bruto_unidad_base,
    dm.mnt_peso_neto_unidad_base as num_peso_neto_unidad_base,
    dm.cod_unidad_peso,
    dm.mnt_peso_bruto_kg as num_peso_bruto_kg,
    dm.mnt_peso_neto_kg as num_peso_neto_kg,
    dm.flg_conversion_kg as flg_conversion_kg,
    dm.num_numerador_kg as num_numerador_kg,
    dm.num_denominador_kg as num_denominador_kg,
    dm.mnt_peso_convertido_kg as num_peso_convertido_kg,
    dm.flg_unidad_comercial as flg_unidad_comercial,
    dm.cod_unidad_comercial_material as cod_unidad_comercial_material,
    dm.mnt_peso_bruto_unidad_comercial as num_peso_bruto_unidad_comercial,
    dm.cod_unidad_peso_comercial as cod_unidad_peso_comercial,
    dm.mnt_peso_unidad_comercial_kg as num_peso_unidad_comercial_kg,
    safe_cast(dm.num_numerador_conversion_uco as int) as num_numerador_conversion_uco,
    safe_cast(dm.num_denominador_conversion_uco as int) as num_denominador_conversion_uco,
    dm.mnt_peso_bruto_unidad_base_calculado as num_peso_bruto_unidad_base_calculado,
    case when dm.mnt_peso_neto_kg=0 then 1 else round(dm.mnt_peso_bruto_unidad_base_calculado/dm.mnt_peso_neto_kg - 1, 4) end num_variacion_peso_uco_unidad_base,
    dm.cod_planner,
    case when dm.flg_sujeto_a_lote = 'X' then TRUE ELSE FALSE end as flg_sujeto_a_lote,
    dm.fec_creacion_material,
    case 
      when dm.cod_tipo_material in ('ZFER','ZHAW') and dm.fec_creacion_material > '2024-03-11' and ucdm.id_material is not null then 'UCDM'
      when dm.cod_tipo_material in ('ZLER','ZROH') and dm.fec_creacion_material > '2024-03-18' and ucdm.id_material is not null then 'UCDM'
      when dm.cod_tipo_material in ('ZERS','ZHIB','ZNLA') and dm.fec_creacion_material >= '2024-07-01' and ucdm.id_material is not null then 'UCDM'
      when dm.cod_tipo_material not in ('ZFER','ZHAW','ZLER','ZROH','ZERS','ZHIB','ZNLA') then null 
      else 'Planeamiento'
    end as des_equipo_creador, 
    dm.cod_usuario_creador,
    dm.fec_ultima_modificacion,
    dm.cod_usuario_ultima_modificacion,
    dm.flg_alicorp as flg_alicorp,
    dm.flg_ali_itdvco as flg_alicorp_intradevco,
    dm.num_tiempo_vida_anterior,
    dm.cod_unidad_tiempo_vida_ant as cod_unidad_tiempo_vida_anterior,
    dm.fec_tiempo_vida_ant as fec_tiempo_vida_anterior,
    dm.flg_tiempo_vida as flg_tiempo_vida,
    dm.cod_bloqueo_venta,
    dm.cod_negocio,
    dm.des_grupo_materiales1 as des_grupo_material1,
    dm.cod_subnegocio,
    dm.des_grupo_materiales2 as des_grupo_material2,
    dm.cod_marca,
    dm.des_grupo_materiales4 as des_grupo_material4,
    dm.cod_unidad_almacenamiento as cod_unidad_almacenamiento,
    safe_cast(dm.num_numerador_conv_unidad_almacenamiento as int) as num_numerador_conversion_unidad_almacenamiento,
    safe_cast(dm.num_denominador_conv_unidad_almacenamiento as int) as num_denominador_conversion_unidad_almacenamiento,
    dm.mnt_peso_bruto_almacenamiento as num_peso_bruto_almacenamiento,
    dm.mnt_peso_neto_almacenamiento as num_peso_neto_almacenamiento,
    dm.num_numerador_conversion_paleta as num_numerador_conversion_paleta,
    dm.num_denominador_conversion_paleta as num_denominador_conversion_paleta,
    dm.mnt_peso_neto_paleta as num_peso_neto_paleta, 
    dm.mnt_volumen_unidad_base as num_volumen_unidad_base,
    dm.cod_unidad_volumen_base as cod_unidad_volumen_base, 
    SAFE_CAST(NULL AS BOOLEAN) AS flg_fert_hawa, -- case when hfs.id_material is not null then TRUE else FALSE end flg_fert_hawa,
    SAFE_CAST(NULL AS STRING) AS cod_estado, -- hfs.status,
    SAFE_CAST(NULL AS STRING) AS cod_estado_nuevo, -- hfs.flg_status_nuevo as cod_estado_nuevo,
    --case when cu03.cod_material is not null then TRUE else FALSE end flg_raciolizacion_cu03,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_raciolizacion_cu03,
    dm.cod_material_reemplazo,
    dm.cod_material_reemplazo_recursivo,
    case when ms.id_material is not null then TRUE else FALSE end flg_stock,
    dm.flg_lmt as flg_lista_material,
    dm.cod_centros_lmt as cod_centro_concatenado_lista_material,
    case when 
            (dm.cod_tipo_material = 'ZROH' and 
                ((dm.cod_material like 'M77%' and LENGTH(dm.cod_material) = 10) or 
                (dm.cod_material not like 'EA77%' and LENGTH(dm.cod_material) != 10)))
            or
            (dm.cod_tipo_material = 'ZLER' and 
                (dm.cod_material not like 'M77%' and LENGTH(dm.cod_material) != 10))
            and
            (LENGTH(dm.cod_material) = 10 and not REGEXP_CONTAINS(dm.cod_material, r'[^a-zA-Z0-9Ñ]'))
        then TRUE
        else FALSE
    end as flg_intradevco,
    SAFE_CAST(NULL AS BOOLEAN) AS flg_excepcion_granel, -- case when hfs.cod_unidad_base not in ('KG','T','L','M2') then TRUE else FALSE end flg_excepcion_granel,
    case when dm.cod_material like 'H%' or REGEXP_CONTAINS(dm.cod_material, r'[^a-zA-Z0-9]') then FALSE else TRUE end flg_zhal,
    dm.cod_grupo_tipo_posicion_general,
    dm.cod_ramo,
    case 
      when bga.cod_grupo_articulo is not null then TRUE 
      else FALSE
    end as flg_grupo_articulo_2,
    case
      when dm.mnt_peso_bruto_unidad_base * dm.mnt_peso_neto_unidad_base = 0 then FALSE
      when dm.mnt_peso_bruto_unidad_base < dm.mnt_peso_neto_unidad_base then FALSE
      else TRUE
    end as flg_peso_bruto,
    case
     when emz.id_material is null then true
     else false
    end as flg_exclusion_categoria_valorizacion,
    case
      when za.id_material is not null then TRUE
      else FALSE
    end as flg_mrp_activo,
    dm.cod_condicion_almacenaje, 
    mcs.cnt_stock,
    -- case 
    --   when mc001.id_material is not null then 'X' 
    --   else null
    -- end as est_clase_001, 
    SAFE_CAST(NULL AS STRING) AS est_clase_001,
    -- case 
    --   when mc023.id_material is not null then 'X' 
    --   else null
    -- end as est_clase_023,
    SAFE_CAST(NULL AS STRING) AS est_clase_023,
    -- case 
    --   when mc001.id_material is null or mc023.id_material is null then TRUE
    --   else FALSE
    -- end as flg_clase_material, 
    SAFE_CAST(NULL AS BOOLEAN) AS flg_clase_material,
    dm.des_responsable_material, 
    'Hadjie Tarazona' as des_responsable_material_indirecto,
    SAFE_CAST(NULL AS DATE) AS fec_movimiento_consumo_201_261, -- bc2.fec_movimiento as fec_movimiento_consumo_201_261,
    SAFE_CAST(NULL AS DATE) AS fec_movimiento_consumo_101, -- bc1.fec_movimiento as fec_movimiento_consumo_101,
    SAFE_CAST(NULL AS DATE) AS fec_fin_validez_contrato, -- bco.fec_fin_validez_documento as fec_fin_validez_contrato,
    dm.cod_bloqueo_comercial, 
    case
      -- when hfs.ind_exportacion = 'E' then 'David'
      when crd.des_categoria is null then 'Sin responsable'
      else crd.des_responsable 
    end as des_responsable_distribucion
  from datos_material dm
  left join `{silver_project_id}.slv_gobierno.ptp_categoria_responsable_distribucion` crd 
    on crd.des_categoria = dm.des_categoria
--  left join base_consumo_201_261 bc2
--    on bc2.id_material = dm.id_material and bc2.val_ranking = 1
--  left join base_consumo_101 bc1
--    on bc1.id_material = dm.id_material and bc1.val_ranking = 1
--  left join base_contratos bco 
--    on bco.id_material = dm.id_material

  -- left join material_clase_001 mc001
  --   on mc001.id_material = dm.id_material
  -- left join material_clase_001 mc023
    -- on mc023.id_material = dm.id_material
  left join materiales_cantidad_stock mcs
    on dm.id_material = mcs.id_material
  left join zfer_zhaw_activos za
    on za.id_material = dm.id_material
  left join materiales_stock ms
     on dm.id_material = ms.id_material
  left join `{silver_project_id}.slv_gobierno.ptp_grupo_articulo` bga
  on dm.cod_grupo_material = bga.cod_grupo_articulo and dm.cod_tipo_material = bga.cod_tipo_material
  left join `{silver_project_id}.slv_gobierno.ptp_grupo_articulo` gart
    on dm.cod_tipo_material=gart.cod_tipo_material 
      and dm.flg_materia_prima=gart.flg_materia_prima 
        and dm.cod_grupo_articulo_2=gart.cod_grupo_articulo
  left join grp_articulo_propuesto gart_prop
    on dm.cod_tipo_material=gart_prop.cod_tipo_material 
      and dm.flg_materia_prima=gart_prop.flg_materia_prima
  left join `{silver_project_id}.slv_gobierno.ptp_longitud_jerarquia` ljer
    on dm.cod_tipo_material=ljer.cod_tipo_material 
      and dm.num_long_cod_jerarquia=ljer.num_longitud_codigo_jerarquia
--  left join fh_status hfs
--    on dm.id_material=hfs.id_material
  left join material_funcional mf
    on dm.id_material=mf.id_material
  -- left join materiales_racio_cu03 cu03
  --   on mf.cod_material_funcional=cu03.cod_material
  left join exclusion_material_zhal emz
   on dm.id_material=emz.id_material
  left join materiales_ucdm ucdm
    on dm.id_material=ucdm.id_material
)
select
  'DE-WILSON' des_origen,
  row_number()over(order by cod_material) as val_rownum,
  id_material,
  cod_material,
  des_denominacion_material,
  cod_tipo_material,
  cod_jerarquia,
  cod_plataforma,
  des_plataforma,
  cod_subplataforma,
  des_subplataforma,
  cod_categoria,
  des_categoria,
  cod_familia,
  des_familia,
  cod_variedad,
  des_variedad,
  cod_presentacion,
  des_presentacion,
  cod_categoria_producto,
  flg_excepcion_material,
  num_longitud_codigo_jerarquia,
  num_longitud_correcta_jerarquia,
  flg_materia_prima,
  flg_dummy,
  cod_material_interfaz,
  est_longitud_material,
  cod_grupo_material,
  des_grupo_material,
  flg_grupo_articulo,
  cod_grupo_articulo_propuesto,
  cod_grupo_articulo_2,
  cod_grupo_articulo_3,
  cod_sociedad,
  flg_centro,
  flg_organizacion_venta,
  cod_unidad_base,
  cod_bloqueo,
  cod_grupo_transporte,
  des_grupo_transporte,
  num_tiempo_vida,
  num_tiempo_duracion,
  cod_unidad_tiempo_vida,
  est_actualizacion,
  est_actualizacion_completa,
  cod_duenio_marca,
  des_duenio_marca,
  cod_onu_cubso,
  cod_unidad_tiempo,
  num_peso_bruto_unidad_base,
  num_peso_neto_unidad_base,
  cod_unidad_peso,
  num_peso_bruto_kg,
  num_peso_neto_kg,
  flg_conversion_kg,
  num_numerador_kg,
  num_denominador_kg,
  num_peso_convertido_kg,
  flg_unidad_comercial,
  cod_unidad_comercial_material,
  num_peso_bruto_unidad_comercial,
  cod_unidad_peso_comercial,
  num_peso_unidad_comercial_kg,
  num_numerador_conversion_uco,
  num_denominador_conversion_uco,
  num_peso_bruto_unidad_base_calculado,
  num_variacion_peso_uco_unidad_base,
  cod_planner,
  flg_sujeto_a_lote,
  fec_creacion_material,
  des_equipo_creador,
  cod_usuario_creador,
  fec_ultima_modificacion,
  cod_usuario_ultima_modificacion,
  flg_alicorp,
  flg_alicorp_intradevco,
  num_tiempo_vida_anterior,
  cod_unidad_tiempo_vida_anterior,
  fec_tiempo_vida_anterior,
  flg_tiempo_vida,
  cod_bloqueo_venta,
  cod_negocio,
  des_grupo_material1,
  cod_subnegocio,
  des_grupo_material2,
  cod_marca,
  des_grupo_material4,
  cod_unidad_almacenamiento,
  num_numerador_conversion_unidad_almacenamiento,
  num_denominador_conversion_unidad_almacenamiento,
  num_peso_bruto_almacenamiento,
  num_peso_neto_almacenamiento,
  num_numerador_conversion_paleta,
  num_denominador_conversion_paleta,
  num_peso_neto_paleta,
  num_volumen_unidad_base,
  cod_unidad_volumen_base,
  flg_fert_hawa,
  cod_estado,
  cod_estado_nuevo,
  flg_raciolizacion_cu03,
  cod_material_reemplazo,
  cod_material_reemplazo_recursivo,
  flg_stock,
  flg_lista_material,
  cod_centro_concatenado_lista_material,
  flg_intradevco,
  flg_excepcion_granel,
  flg_zhal,
  cod_grupo_tipo_posicion_general,
  cod_ramo,
  flg_grupo_articulo_2,
  flg_peso_bruto,
  flg_exclusion_categoria_valorizacion,
  flg_mrp_activo,
  cod_condicion_almacenaje,
  cnt_stock,
  est_clase_001,
  est_clase_023,
  flg_clase_material,
  des_responsable_material,
  des_responsable_material_indirecto,
  fec_movimiento_consumo_201_261,
  fec_movimiento_consumo_101,
  fec_fin_validez_contrato,
  cod_bloqueo_comercial,
  des_responsable_distribucion,
  cod_material as val_dbkey,
  current_datetime('America/Lima') as fec_proceso
from base_final;

merge into `{horizonte_project_id}.hzt_planeamiento.horizonte_material` t
using (
  with
  mats_alicorp as (
    select
      c.id_material,
      c.cod_sociedad,
      ps.num_prioridad,
      row_number()over(partition by c.id_material order by ps.num_prioridad) as val_rownum
    from `{silver_project_id}.slv_modelo_material.horizonte_material_centro` c
    join `{silver_project_id}.slv_gobierno.ptp_prioridad_sociedad` ps
      on c.cod_sociedad = ps.cod_sociedad
    --where c.cod_sociedad in ('PE11', 'PE21', 'PE14', 'PE16')
  )
  select distinct
    mb.id_material,
    ma.cod_sociedad
  from `{silver_project_id}.slv_modelo_material.horizonte_material_aux` mb
  join mats_alicorp ma
    on mb.id_material = ma.id_material
  where coalesce(mb.cod_bloqueo,'') != '03'
  and coalesce(mb.cod_duenio_marca, '') = ''
  and ma.val_rownum = 1
) s
on (t.id_material=s.id_material)
when matched then
update set 
  t.cod_sociedad = s.cod_sociedad;

delete from `{horizonte_project_id}.hzt_planeamiento.horizonte_material`
where coalesce(cod_sociedad, '') = ''
and id_material not in (
    select distinct
      id_material
    from `{silver_project_id}.slv_modelo_material.horizonte_material_centro`
    /*where cod_sociedad in ('PE11', 'PE21', 'PE14', 'PE13', 'PE16')
    and coalesce(cod_bloqueo_centro,'') != '03'*/
);
