-- 1. Ingresos por género – Comparación de los ingresos 
-- totales generados por clientes hombres frente a mujeres.

select sexo, sum(monto_de_comprar) as TotalComprado
from cliente
group by sexo

-- 2. Usuarios de descuentos con alto gasto – Identificación de clientes que utilizaron 
-- descuentos pero cuyo gasto superó el importe medio de compra.

select idcliente,monto_de_comprar
from cliente
where descuento_aplicado='YES' AND monto_de_comprar>=(select avg(monto_de_comprar) from cliente)

--3. Los 5 productos mejor valorados – Identificación de los productos 
--con las valoraciones medias más altas.

select articulo_comprado,
       cast(avg(calificacion_del_cliente) as decimal(10,2)) as promedio_calificacion_cliente
from cliente
group by articulo_comprado

-----------------------------------------------------------------------------------------------

select top 5 articulo_comprado,
       cast(avg(calificacion_del_cliente) as decimal(10,2)) as promedio_calificacion_cliente
from cliente
group by articulo_comprado
order by cast(avg(calificacion_del_cliente) as decimal(10,2)) desc


--4. Comparación de tipos de envío – Comparación de los importes 
-- medios de compra entre envíos estándar y exprés.

select tipo_de_envio,
       avg(monto_de_comprar) as promedio_monto_de_compra
from cliente
where tipo_de_envio in ('Standard','Express')
group by tipo_de_envio


-- 5. Suscriptores frente a no suscriptores 
-- Comparación del gasto medio y los ingresos totales según el estado de suscripción.

select estado_de_suscripcion,
count(idcliente) as totaldeclientes,
AVG(monto_de_comprar) as GastoPromedio,
sum(monto_de_comprar) as TotalComprado
from cliente
group by estado_de_suscripcion
order by TotalComprado,GastoPromedio desc


--6. Productos con alta dependencia de descuentos 
--   Identificación de los 5 productos con mayor porcentaje de compras realizadas con descuento.

select top 5 articulo_comprado,
       round(100.0*sum(case when descuento_aplicado='YES' then 1 else 0 end)/count(*),2) as tasa_de_descuento
from cliente
group by articulo_comprado
order by tasa_de_descuento desc


--7. Segmentación de clientes – Clasificación de los clientes en 
--   segmentos (nuevos, recurrentes y fieles) según su historial de compras.


with tipo_cliente as (
select idcliente,compras_anteriores,
CASE
   WHEN compras_anteriores = 1 then 'Nuevo'
   when compras_anteriores between 2 and 10 then 'Recurrente'
   else 'Leal'
   end as Segmento_cliente
from cliente)

select Segmento_Cliente, count(*) as Numero_de_clientes
from tipo_cliente
group by Segmento_Cliente

--------------------------------------------------------------------------

select idcliente,compras_anteriores,
CASE
   WHEN compras_anteriores = 1 then 'Nuevo'
   when compras_anteriores between 2 and 10 then 'Recurrente'
   else 'Leal'
   end as Segmento_cliente
from cliente


-- 8. Los 3 mejores productos por categoría 
--    Listado de los productos más comprados en cada categoría.


select categoria,
       articulo_comprado,
       count(idcliente) as total_de_pedidos,
       row_number() over(partition by categoria order by count(idcliente) desc) as ranking_de_producto
from cliente
group by categoria,articulo_comprado


------------------------------------------------------------------
select categoria,
       articulo_comprado,
       count(idcliente) as total_de_pedidos
from cliente
group by categoria,articulo_comprado


-----------------------------------------------------------------------------


with cuentadearticulos as(
select categoria,
       articulo_comprado,
       count(idcliente) as total_de_pedidos,
       row_number() over(partition by categoria order by count(idcliente) desc) as ranking_de_productos
from cliente
group by categoria,articulo_comprado

)

select ranking_de_productos,categoria,articulo_comprado,total_de_pedidos
from cuentadearticulos
where ranking_de_productos<=3

-- 9. Clientes recurrentes y suscripciones – Análisis de si los clientes con más de 
--    5 compras tienen mayor probabilidad de suscribirse.

select estado_de_suscripcion,
       count(idcliente) as Compras_recurrentes
from cliente
where compras_anteriores>5
group by estado_de_suscripcion














