WITH raw_data AS (
    SELECT * FROM {{ source('walmart', 'walmart_sales_raw') }}
)

SELECT
    Store AS id_tienda,
    TO_DATE(Date, 'DD-MM-YYYY') AS fecha,
    Weekly_Sales AS ventas_semanales,
    CAST(Holiday_Flag AS BOOLEAN) AS es_dia_festivo,
    Temperature AS temperatura,
    Fuel_Price AS precio_combustible,
    CPI AS indice_precios,
    Unemployment AS desempleo
FROM raw_data