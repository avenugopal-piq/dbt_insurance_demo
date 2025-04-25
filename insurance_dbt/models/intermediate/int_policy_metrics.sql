WITH policy_events AS (
    SELECT * FROM {{ ref('stg_policy_events') }}
)

SELECT
    policy_id,
    coverage,
    SUM(written_premium) AS total_written_premium,
    SUM(written_exposure) AS total_written_exposure,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    MIN(effective_date) AS earliest_effective_date,
    MAX(expiration_date) AS latest_expiration_date
FROM policy_events
GROUP BY policy_id, coverage