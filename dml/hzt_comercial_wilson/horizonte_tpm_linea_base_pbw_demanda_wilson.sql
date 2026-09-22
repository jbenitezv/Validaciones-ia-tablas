/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO HORIZONTE_TMP_LINEA_BASE_PWD_DEMANDA
  FECHA DE CREACIÓN: 18/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from `{horizonte_project_id}.hzt_comercial.horizonte_tpm_linea_base_pbw_demanda`
where des_origen = 'DE-WILSON';

insert into `{horizonte_project_id}.hzt_comercial.horizonte_tpm_linea_base_pbw_demanda`
with 
base_pbw as (
  select 
    SAFE_CAST(NULL AS STRING) AS cod_canal,
    left(cod_interlocutor, instr(cod_interlocutor, '/')-1) as cod_cliente, --
    substring(cod_interlocutor, instr(cod_interlocutor, '/')+1, 4) as cod_organizacion_venta,
    substring(cod_interlocutor, instr(cod_interlocutor, '/')+5, 2) as cod_canal_distribucion,
    substring(cod_interlocutor, instr(cod_interlocutor, '/')+7, 2) as cod_sector_comercial,
    upper(substring(cod_interlocutor, instr(cod_interlocutor, '|')+2, 50)) as des_interlocutor,
    case upper(substring(cod_interlocutor, instr(cod_interlocutor, '|')+2, 50))
      when 'DIST.EXLCU.MAYOR' then 'DIST.EXCLU.MAYOR' 
      when 'FERRETERIAS' then 'FERRETERÍAS' 
      when 'PANIFI.INDUSTR.' then 'PANIFI. INDUSTR.' 
      when 'ALTERNATIVO BOD' then 'ALTERN. BODEGAS'
      else upper(substring(cod_interlocutor, instr(cod_interlocutor, '|')+2, 50))
    end nom_cliente, --
    left(cod_producto, instr(cod_producto, '|')-2) as cod_material,
    substring(cod_producto, instr(cod_producto, '|')+2, 60) as nom_material,
    safe_cast(num_linea_base_tonelada as NUMERIC) as plan_linea_base_ton,
    case 
      when substring(cod_interlocutor, instr(cod_interlocutor, '/')+7, 2) = '20' then safe_cast(num_linea_base_tonelada as NUMERIC)
      else null 
    end as core,
    case 
      when substring(cod_interlocutor, instr(cod_interlocutor, '/')+7, 2) = '21' then safe_cast(num_linea_base_tonelada as NUMERIC)
      else null 
    end as value,
    case 
      when substring(cod_interlocutor, instr(cod_interlocutor, '/')+7, 2) = '22' then safe_cast(num_linea_base_tonelada as NUMERIC)
      else null 
    end as intradevco,
    case 
      when substring(cod_interlocutor, instr(cod_interlocutor, '/')+7, 2) = '31' then safe_cast(num_linea_base_tonelada as NUMERIC)
      else null 
    end as alicorp_soluciones,
    num_precio_lista_planificado as plan_precio_lista,
    num_costo_unitario_planificado as plan_costo_planificado
  from `{silver_project_id}.slv_gobierno.otc_plantilla_promocion_pbw` a
),
base_bloqueados as (
  select distinct 
    a.cod_material_funcional
  from `{silver_project_id}.slv_modelo_material.horizonte_material_aux` a 
  where a.des_bloqueo = 'Bloqueo Total' 
  and a.cod_tipo_material in ('ZFER','ZHAW')
)
, base_avance_ventas_hist as (
  select distinct 
    cod_material 
  from `{silver_project_id}.slv_gobierno.otc_avance_venta_tpm`
  where des_periodo in ( 'Abr-23', 'May-23', 'Jun-23', 'Jul-23', 'Ago-23', 'Set-23')
)
, base_avance_ventas_plan as (
  select distinct 
    cod_material 
  from `{silver_project_id}.slv_gobierno.otc_avance_venta_tpm`
  where des_periodo in ('Oct-23','Nov-23','Dic-23')
)
, base_pbw_agrupada as (
  select 
    cod_cliente,
    cod_organizacion_venta,
    case cod_organizacion_venta 
      when '1011' then 'CMP' 
      when '1012' then 'B2B' 
    end as negocio,
    nom_cliente,
    a.cod_material,
    nom_material,
    sum(plan_linea_base_ton) as linea_base_ton_pbw,
    sum(core) as core,
    sum(value) as value, 
    sum(intradevco) as intradevco, 
    sum(alicorp_soluciones) as alicorp_soluciones
  from base_pbw a
  left join base_bloqueados b 
    on a.cod_material = b.cod_material_funcional
  left join base_avance_ventas_hist c 
    on a.cod_material = c.cod_material
  left join base_avance_ventas_plan d
    on a.cod_material = d.cod_material
  where b.cod_material_funcional is null 
  and (c.cod_material is not null or d.cod_material is not null)
  group by cod_cliente, cod_organizacion_venta, nom_cliente, a.cod_material, nom_material
),
base_demanda as (
  select 
    left(des_negocio, instr(des_negocio, '-') - 1) as cod_negocio,
    substring(des_negocio, instr(des_negocio, '-') + 1, length(des_categoria)) as des_negocio,
    left(des_categoria, instr(des_categoria, '-') - 1) as cod_categoria,
    substring(des_categoria, instr(des_categoria, '-') + 1, length(des_categoria)) as des_categoria,
    left(des_familia, instr(des_familia, '-') - 1) as cod_familia,
    substring(des_familia, instr(des_familia, '-') + 1, length(des_familia)) as des_familia,
    left(des_producto, instr(des_producto, '-') - 1) as cod_material,
    substring(des_producto, instr(des_producto, '-') + 1, length(des_producto)) as nom_material,
    left(des_oficina_venta_s4h, instr(des_oficina_venta_s4h, '-') - 1) as cod_oficina_ventas,
    substring(des_oficina_venta_s4h, instr(des_oficina_venta_s4h, '-') + 1, length(des_oficina_venta_s4h)) as des_oficina_ventas,
    left(des_grupo_vendedor_s4h, instr(des_grupo_vendedor_s4h, '-') - 1) as cod_grupo_vendedores,
    substring(des_grupo_vendedor_s4h, instr(des_grupo_vendedor_s4h, '-') + 1, length(des_grupo_vendedor_s4h)) as des_grupo_vendedores,
    left(des_grupo_precio , instr(des_grupo_precio, '-') - 1) as cod_grupo_precios,
    substring(des_grupo_precio, instr(des_grupo_precio, '-') + 1, length(des_grupo_precio)) as des_grupo_precios,
    left(des_zona_cliente, instr(des_zona_cliente, '-') - 1) as cod_zona_clientes,
    substring(des_zona_cliente, instr(des_zona_cliente, '-') + 1, length(des_zona_cliente)) as des_zona_clientes,
    num_volumen_mes_anterior,
    num_volumen_mes_actual,
    num_volumen_mes_siguiente
  from `{silver_project_id}.slv_gobierno.otc_tpm_tonelada`
  where des_ratio = 'BASELINE'
),
base_demanda_transformada as (
  select 
    case 
      when des_negocio in ('Core','Value') then 'CMP'
      when left(des_negocio,4) = 'AASS' then 'B2B'
    end as negocio,
    cod_material,
    cod_grupo_vendedores,
    des_grupo_vendedores,
    cod_grupo_precios,
    case 
      when des_grupo_vendedores like '%CENCOSUD%' then 'CENCOSUD'
      when des_grupo_vendedores like '%TOTTUS%' then 'TOTTUS'
      when des_grupo_vendedores like '%SPSA%' then 'SUPERMERCADOS PERUANOS'
      when des_grupo_precios='MiniMark./Estac.Serv' then 'MINIMARKETS TRADICIONAL'
      else upper(des_grupo_precios)
    end nom_interlocutor,
    case 
      when des_grupo_vendedores like '%CENCOSUD%' then 'des_grupo_vendedores'
      when des_grupo_vendedores like '%TOTTUS%' then 'des_grupo_vendedores'
      when des_grupo_vendedores like '%SPSA%' then 'des_grupo_vendedores'
      else 'des_grupo_precios'
    end nom_columna_cruce,
    num_volumen_mes_anterior,
    num_volumen_mes_actual,
    num_volumen_mes_siguiente
  from base_demanda
),
base_demanda_agrupada as (
  select
    negocio,
    cod_material,
    nom_interlocutor,
    nom_columna_cruce,
    sum(coalesce(num_volumen_mes_siguiente, 0)) as linea_base_ton_demanda 
  from base_demanda_transformada
  group by negocio, cod_material, nom_interlocutor, nom_columna_cruce
),
base_cruzada as (
  select
    lpad(a.cod_cliente, 10, '0') as cod_cliente,
    a.cod_organizacion_venta,
    a.negocio,
    a.nom_cliente,
    b.nom_columna_cruce,
    a.cod_material,
    a.nom_material,
    SAFE_CAST(NULL AS STRING) AS categoria, -- j.des_categoria as categoria,
    SAFE_CAST(NULL AS STRING) AS familia, -- j.des_familia as familia,
    SAFE_CAST(NULL AS STRING) AS gramaje, -- j.des_presentacion as gramaje,
    a.linea_base_ton_pbw,
    a.core,
    a.value, 
    a.intradevco, 
    a.alicorp_soluciones,
    b.linea_base_ton_demanda,
    case 
      when a.linea_base_ton_pbw > 0 or b.linea_base_ton_demanda > 0 then 1
      when coalesce(a.linea_base_ton_pbw, 0) = 0 and coalesce(b.linea_base_ton_demanda, 0) = 0 then 0
    end flg_valida_ton,
    ROUND(NULLIF((b.linea_base_ton_demanda - a.linea_base_ton_pbw) / 
    NULLIF(a.linea_base_ton_pbw, 0), 0), 2) AS mnt_porcentaje_variacion
  from base_pbw_agrupada a
  left join base_demanda_agrupada b
    on a.negocio = b.negocio 
      and a.cod_material = b.cod_material
        and upper(a.nom_cliente) = upper(b.nom_interlocutor)
  left join `{silver_project_id}.slv_modelo_material.horizonte_material_aux` ma
    on a.cod_material = ma.cod_material_funcional
  left join `{silver_project_id}.slv_modelo_material.horizonte_material` m
    on ma.id_material=m.id_material
--  left join `{silver_project_id}.slv_modelo_material.horizonte_material_jerarquia` j
--    on m.cod_jerarquia_material=j.cod_jerarquia_material
  left join base_avance_ventas_hist c 
    on a.cod_material = c.cod_material
  left join base_avance_ventas_plan d
    on a.cod_material = d.cod_material
  where (c.cod_material is not null or d.cod_material is not null)
),
base_final as (
  select 
    case 
      when nom_cliente in ('CENCOSUD', 'SUPERMERCADOS PERUANOS', 'TOTTUS') then 'Moderno'
      else 'Tradicional'
    end as tip_canal,
    cod_cliente,
    cod_organizacion_venta,
    negocio as val_subdominio,
    nom_cliente,
    nom_columna_cruce,
    cod_material,
    nom_material,
    categoria as val_categoria,
    familia as val_familia,
    gramaje as des_gramaje,
    linea_base_ton_pbw as num_linea_base_ton_pbw,
    core as num_core,
    value as num_value,
    intradevco as num_intradevco,
    alicorp_soluciones as num_alicorp_solucion,
    linea_base_ton_demanda as num_linea_base_ton_demanda,
    flg_valida_ton,
    mnt_porcentaje_variacion
  from base_cruzada
)
select 
  'DE-WILSON' des_origen,
  row_number()over(order by cod_material, cod_cliente, nom_cliente) as val_rownum,
  'PE11' as cod_sociedad,
  tip_canal,
  cod_cliente,
  cod_organizacion_venta,
  val_subdominio,
  nom_cliente,
  nom_columna_cruce,
  cod_material,
  nom_material,
  val_categoria,
  val_familia,
  des_gramaje,
  num_linea_base_ton_pbw,
  num_core,
  num_value,
  num_intradevco,
  num_alicorp_solucion,
  num_linea_base_ton_demanda,
  flg_valida_ton,
  mnt_porcentaje_variacion,
  coalesce(cod_material,'') || coalesce(val_subdominio,'') || coalesce(nom_cliente,'') as val_dbkey
from base_final;