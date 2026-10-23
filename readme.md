# Walmart Sales Analytics: ELT con dbt y Snowflake

Este repositorio contiene la estructura y los modelos de transformación de datos para el análisis de ventas de Walmart, cruzando el volumen de facturación con indicadores macroeconómicos. El proyecto implementa un flujo ELT moderno, utilizando Snowflake como almacén de datos (Data Warehouse) y dbt (data build tool) para la capa de transformación y orquestación.

## Stack Tecnológico
* **Data Warehouse:** Snowflake
* **Transformación y Modelado:** dbt Cloud
* **Control de Versiones:** Git / GitHub
* **Lenguaje:** SQL (dialecto Snowflake)

## Arquitectura de Datos (Medallón adaptada a dbt)

El pipeline de transformación está dividido en dos capas principales para separar la limpieza técnica de la lógica de negocio:

### 1. Capa Staging (Bronce / Base)
* **Objetivo:** Estandarizar formatos, renombrar columnas al español y castear tipos de datos desde la fuente cruda (`RAW_DATA`).
* **Modelo principal:** `stg_walmart_sales.sql`
* **Materialización:** Vista (`view`). Esto asegura que no se duplique el almacenamiento de los datos base, procesándose en tiempo de ejecución.

### 2. Capa Marts (Oro / Negocio)
* **Objetivo:** Agrupar y calcular métricas definitivas listas para consumo en herramientas de Business Intelligence (Power BI, Tableau).
* **Modelo principal:** `fct_ventas_mensuales_macro.sql`
* **Lógica:** Agrupación mensual de ventas cruzada con promedios de temperatura, precio de combustible y tasas de desempleo mediante funciones de agregación.
* **Materialización:** Tabla física (`table`). Esto optimiza el rendimiento de las consultas de lectura de los dashboards finales.

## Pruebas de Calidad (Data Testing)
Se implementaron pruebas automatizadas nativas de dbt a través de archivos `.yml` para garantizar la integridad de los datos antes de compilar la capa de negocio:
* `not_null`: Validación en las llaves primarias y fechas (ej. `id_tienda`, `fecha`) para evitar la propagación de registros huérfanos o corrompidos.

## Linaje y Documentación
El proyecto aprovecha la función `{{ ref() }}` de dbt para construir dependencias dinámicas entre la capa Staging y la capa Marts, lo que permite la generación automática de un grafo de linaje (Lineage Graph) y un diccionario de datos navegable ejecutando `dbt docs generate`.

## Ejecución del Proyecto
Para ejecutar y probar las transformaciones en tu propio entorno:
1. Clona este repositorio.
2. Configura tu conexión a Snowflake en `profiles.yml` o en dbt Cloud usando autenticación Key-Pair.
3. Ejecuta el pipeline completo y las pruebas de calidad con:
   ```bash
   dbt build
   ```