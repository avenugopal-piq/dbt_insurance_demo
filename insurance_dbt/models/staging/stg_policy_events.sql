WITH source AS (
    SELECT * FROM {{ ref('policyevents') }}
)

SELECT
    transaction_id,
    policy_id,
    term,
    event_type,
    CAST(event_date AS DATE) AS event_date,
    CAST(effective_date AS DATE) AS effective_date,
    CAST(expiration_date AS DATE) AS expiration_date,
    coverage,
    prior_written_premium,
    written_premium_change,
    written_premium,
    prior_written_exposure,
    written_exposure_change,
    written_exposure,
    CURRENT_TIMESTAMP() AS loaded_at
FROM source