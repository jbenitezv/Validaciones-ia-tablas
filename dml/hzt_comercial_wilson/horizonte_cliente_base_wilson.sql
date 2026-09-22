/*
***************************************
  USUARIO DE CREACIÓN : JBENITEZ
  DETALLE : MODELO  
  FECHA DE CREACIÓN: 21/09/2026
  
  HISTORIAL DE MODIFICACIÓN:		
  --------------------------
  FECHA     |  USUARIO  |  DETALLE  
  ---------------------------------
***************************************
*/

delete from `{horizonte_project_id}.hzt_comercial.horizonte_cliente_base` where des_origen = 'DE-WILSON';
insert into `{horizonte_project_id}.hzt_comercial.horizonte_cliente_base`

with
base_org_venta as (
  select
    SAFE_CAST(NULL AS STRING) as cod_interlocutor,
    SAFE_CAST(NULL AS STRING) as organizaciones_venta 
--   select
--     substring(id_interlocutor,15,10) as cod_interlocutor,
--     string_agg(distinct cod_organizacion_venta, ',') as organizaciones_venta 
--   `{silver_project_id}.slv_modelo_interlocutor.horizonte_cliente_organizacion_venta`
--   where cod_sociedad in (
--     'PE11',	---ALICORP 
--     'PE21',	---INTRADEVCO
--     'PE12',
--     'EC13', --- VITAPRO
--     'PE15', ---ALICORP SOLUCIONES
--     'PE20', ---GLOBAL
--     'PE14', ---MASTERBREAD
--     'PE18', ---R TRADING
--     'PE16', ---PROORIENTE
--     'UY11', ---ALICORP URUGUAY
--     'UY12', ---COLCUN
--     'EC11',
--     'EC12',
--     'CO11') 
--   and flg_bloqueo_ventas is null
-- group by cod_interlocutor
),
base_alicorp as (
  select 
    SAFE_CAST(NULL AS STRING) AS cod_sociedad, 
    SAFE_CAST(NULL AS STRING) AS cod_interlocutor
  -- select distinct 
  --   cod_sociedad, 
  --   substring(id_interlocutor,15,10) as cod_interlocutor
  -- from `{silver_project_id}.slv_modelo_interlocutor.horizonte_cliente_organizacion_venta`
  -- where cod_organizacion_venta in ('1011','1012') 
  -- and flg_bloqueo_ventas is null
),
base_documentos as (
  select
    substring(id_interlocutor,15,10) as cod_interlocutor, --ANTERIORMENTE SE TOMABA DE 11,10 PORQ EL VALOR ERA ITL-SAPS4- AHORA ES ITL-DE-WILSON
    cod_tipo_documento,
    des_numero_documento
  from `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_documento`
  where num_orden = 1
),
base_telefono as (
  select distinct 
    substring(id_interlocutor,15,10) as cod_interlocutor, 
    flg_telefono_fijo
  from `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_telefono` 
  where flg_telefono_fijo = 0
),
base_correos as (
  select distinct 
    substring(id_interlocutor,15,10) as cod_interlocutor 
  from `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_email`
),
base_comentario as (
  select distinct 
    substring(e.id_interlocutor,15,10) as cod_interlocutor  
  from `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor_email` e
  join `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor` i 
    on e.id_interlocutor = i.id_interlocutor
  -- where i.cod_grupo_interlocutor='ZENT'
  -- and e.des_comentario_email = 'FE-PE11'
),
total_facturas as (
  select 
    SAFE_CAST(NULL AS STRING) as cod_interlocutor,
    SAFE_CAST(NULL AS STRING) as cod_organizacion_venta

  -- select distinct 
  --   cod_responsable_pago as cod_interlocutor,
  --   cod_organizacion_venta
  -- from `{silver_project_id}.slv_modelo_ventas.documento_cabecera` dc
  -- join `{silver_project_id}.slv_modelo_ventas.s4_documento_cabecera_aux` aux
  --   on aux.id_documento = dc.id_documento
  -- where fec_documento>=DATE_TRUNC(CURRENT_DATE(), YEAR) 
  -- and cod_clase_documento='ZF01'
  -- and cod_organizacion_venta in ('1011','1012')
  -- and cod_canal_distribucion='01'
  -- and dc.periodo >"1900-01-01" and aux.periodo > "1900-01-01"
  --   union all
  -- select distinct 
  --   id_cliente_origen as cod_interlocutor,
  --   cod_organizacion_venta
  -- from  `{silver_project_id}.slv_modelo_ventas.documento_cabecera` dc
  -- join `{silver_project_id}.slv_modelo_ventas.s4_documento_cabecera_aux` aux 
  --   on aux.id_documento = dc.id_documento
  -- where fec_documento>=DATE_TRUNC(CURRENT_DATE(), YEAR) -- año actual
  -- and cod_clase_documento='ZF01'
  -- and cod_organizacion_venta in ('1011','1012')
  -- and cod_canal_distribucion='01'
  -- and dc.periodo >"1900-01-01" and aux.periodo > "1900-01-01"
),
clientes_facturas as (
  select 
    cod_interlocutor,
    case when min(cod_organizacion_venta)='1011' then 'CMP' else 'B2B' end as subdominio_ventas
  from total_facturas
  group by cod_interlocutor
),
clientes_base_2 as (
  select
    substring(i.id_interlocutor,15,10) as cod_cliente,
    i.cod_grupo_interlocutor as cod_grupo_cliente,
    i.cod_pais as cod_pais_cliente,
    i.nom_interlocutor as nombre_cliente,
    case 
      when i.flg_persona_natural is true then true 
      when i.flg_persona_natural is false then false 
    end as flag_persona_natural,
    i.cod_idioma as idioma_cliente,
    i.cod_contacto,
    i.cod_ubigeo,
    i.des_poblacion as poblacion,
    i.des_distrito as distrito,
    i.cod_region,
    i.des_direccion as direccion,
    i.cod_zona_transporte as zona_transporte,
    i.fec_creacion as fec_creacion_cliente,
    i.cod_usuario_creador,
    bi.cod_tipo_documento as tipo_documento,
    bi.des_numero_documento as numero_documento,
    SAFE_CAST(NULL AS STRING) AS cod_sociedad, --ba.cod_sociedad,
    SAFE_CAST(NULL AS STRING) AS organizaciones_venta, --ov.organizaciones_venta,
    case when bt.cod_interlocutor is not null then true else null end as flag_telefono,
    case when bc.cod_interlocutor is not null then true else null end as flag_email,
    case when bm.cod_interlocutor is not null then true else false end as flag_comentario,
    case 
      when i.flg_bloqueo_cliente is true then true 
      when i.flg_bloqueo_cliente is false then false 
    end as flg_bloqueo_cliente,
    cf.subdominio_ventas
  from `{silver_project_id}.slv_modelo_interlocutor.horizonte_interlocutor` i
  -- join base_alicorp ba
  --   on substring(i.id_interlocutor,15,10)=ba.cod_interlocutor
  -- join base_org_venta ov
  --   on substring(i.id_interlocutor,15,10) = ov.cod_interlocutor
  left join base_documentos bi
    on substring(i.id_interlocutor,15,10) = bi.cod_interlocutor
  left join base_telefono bt
    on substring(i.id_interlocutor,15,10) = bt.cod_interlocutor
  left join base_correos bc
    on substring(i.id_interlocutor,15,10) = bc.cod_interlocutor
  left join base_comentario bm
    on substring(i.id_interlocutor,15,10) = bm.cod_interlocutor
  left join clientes_facturas cf
    on substring(i.id_interlocutor,15,10) = cf.cod_interlocutor
  -- where i.cod_grupo_interlocutor in ('ZENT','ZDES','ZDEM','ZNJE')
  -- and coalesce(i.cod_busqueda,'') != 'CL. AREA'
  -- and i.flg_bloqueo_cliente is null
),
clientes_base as (
  select 
    cb.cod_cliente,
    cb.cod_grupo_cliente,
    cb.cod_pais_cliente,
    cb.nombre_cliente as nom_cliente,
    cb.flag_persona_natural as flg_persona_natural,
    cb.tipo_documento as cod_tipo_documento,
    cb.numero_documento as cod_documento,
    length(cb.numero_documento) as cnt_longitud_nif,
    safe_cast(old.num_longitud as INT64) as cnt_longitud_correcta,
    case 
      when cpdd.num_primer_digito is null then false 
      else true 
    end as flg_primer_digito,
    case 
      when cb.organizaciones_venta like '%1011%' then 'CMP' 
      when cb.organizaciones_venta like '%1012%' then 'B2B' 
    end as cod_subdominio,
    cb.cod_sociedad,
    cb.organizaciones_venta as val_organizacion_venta,
    cb.idioma_cliente as cod_idioma_cliente,
    cb.cod_contacto,
    cb.cod_ubigeo,
    case 
      when cp.cod_ubigeo is null then false 
      else true 
    end as flg_cod_ubigeo,
    cp2.cod_ubigeo as cod_ubigeo_sugerido,
    cb.poblacion as des_poblacion,
    cp.des_poblacion as des_poblacion_ubigeo,
    cb.distrito as des_distrito,
    cp.des_distrito as des_distrito_ubigeo,
    cb.cod_region,
    case 
      when cr.cod_region is null then false 
      else true 
    end as flg_region,
    cb.direccion as des_direccion,
    cb.zona_transporte as cod_zona_transporte,
    cb.flg_bloqueo_cliente as flg_bloqueo_cliente,
    cb.flag_telefono as flg_telefono,
    cb.flag_email as flg_email,
    cb.flag_comentario as flg_comentario,
    cb.fec_creacion_cliente,
    cb.cod_usuario_creador,
    cb.subdominio_ventas as cod_subdominio_venta
    from clientes_base_2 cb
    left join `{silver_project_id}.slv_gobierno.otc_cliente_longitud_documento` old
      on cb.tipo_documento=old.cod_pais_tipo_documento
    left join `{silver_project_id}.slv_gobierno.otc_codigo_postal` cp
      on ifnull(cb.cod_pais_cliente,'PE')= cp.cod_pais 
        and cb.cod_ubigeo= cp.cod_ubigeo
    left join `{silver_project_id}.slv_gobierno.otc_codigo_postal` cp2
      on ifnull(cb.cod_pais_cliente,'PE')= cp2.cod_pais 
        and cb.poblacion = cp2.des_poblacion and cb.distrito=cp2.des_distrito
    left join `{silver_project_id}.slv_gobierno.otc_cliente_primer_digito_documento` cpdd
      on cb.tipo_documento=cpdd.cod_pais_tipo_documento 
        and left(cb.numero_documento,2) = safe_cast(cpdd.num_primer_digito as STRING)
    left join `{silver_project_id}.slv_gobierno.otc_codigo_region` cr
      on ifnull(cb.cod_pais_cliente,'PE')=cr.cod_pais 
        and cb.cod_region=cr.cod_region
)
select 
  'DE-WILSON' des_origen,
  row_number() over(order by a.cod_cliente) as val_rownum,
  cod_cliente,
  cod_grupo_cliente,
  cod_pais_cliente,
  nom_cliente,
  flg_persona_natural,
  cod_tipo_documento,
  cod_documento,
  cnt_longitud_nif,
  cnt_longitud_correcta,
  flg_primer_digito,
  cod_subdominio,
  cod_sociedad,
  val_organizacion_venta,
  cod_idioma_cliente,
  cod_contacto,
  cod_ubigeo,
  flg_cod_ubigeo,
  cod_ubigeo_sugerido,
  des_poblacion,
  des_poblacion_ubigeo,
  des_distrito,
  des_distrito_ubigeo,
  cod_region,
  flg_region,
  des_direccion,
  cod_zona_transporte,
  flg_bloqueo_cliente,
  flg_telefono,
  flg_email,
  flg_comentario,
  fec_creacion_cliente,
  cod_usuario_creador,
  cod_subdominio_venta,
  SAFE_CAST(NULL AS STRING) as cod_grupo_precio_alicorp,
  SAFE_CAST(NULL AS STRING) as des_grupo_precio_alicorp,
  a.cod_cliente as val_dbkey,
  CURRENT_DATETIME('America/Lima')as fec_proceso
from clientes_base a 
-- left join (
--   select
--     b.cod_cliente,
--     dov.cod_organizacion_venta,
--     dov.cod_canal_distribucion,
--     dov.cod_sector_comercial,
--     dov.cod_grupo_precio,
--     dov.des_grupo_precio
--   from `{golden_project_id}.gld_cliente.s4_cliente` b
--   cross join unnest(b.det_organizacion_venta) as dov
--   qualify row_number() over (
--     partition by b.cod_cliente
--     order by
--       case 
--         when dov.cod_organizacion_venta = '1011' then 1
--         when dov.cod_organizacion_venta = '1012' then 2
--         else 3
--       end,
--       case 
--         when dov.cod_canal_distribucion = '01' then 1
--         else 2
--       end,
--       dov.cod_sector_comercial,
--       dov.cod_grupo_precio
--   ) = 1
-- ) dov
--   on a.cod_cliente = dov.cod_cliente
--where a.nombre_cliente not like '%MODELO%'