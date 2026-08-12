CREATE TABLE instrument (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    code VARCHAR(20) NOT NULL,
    name_zh VARCHAR(100) NOT NULL,
    market VARCHAR(20) NOT NULL,
    instrument_type VARCHAR(20) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_instrument_market_code
        UNIQUE (market, code)
);


CREATE TABLE market_daily (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    instrument_id BIGINT NOT NULL
        REFERENCES instrument(id),

    trade_date DATE NOT NULL,

    open_price NUMERIC(18,4),
    high_price NUMERIC(18,4),
    low_price NUMERIC(18,4),
    close_price NUMERIC(18,4),

    volume_thousand_shares BIGINT,
    turnover_value_thousand BIGINT,

    return_pct NUMERIC(12,6),
    turnover_rate_pct NUMERIC(12,6),

    shares_outstanding_thousand BIGINT,
    market_cap_million BIGINT,

    last_bid_price NUMERIC(18,4),
    last_ask_price NUMERIC(18,4),

    log_return NUMERIC(12,6),

    market_cap_weight_pct NUMERIC(12,6),
    turnover_value_weight_pct NUMERIC(12,6),

    trade_count BIGINT,

    pe_tse NUMERIC(18,6),
    pe_tej NUMERIC(18,6),

    pb_tse NUMERIC(18,6),
    pb_tej NUMERIC(18,6),

    price_limit_status VARCHAR(20),

    ps_tej NUMERIC(18,6),

    dividend_yield_tse NUMERIC(12,6),
    cash_dividend_yield NUMERIC(12,6),

    price_change NUMERIC(18,4),
    high_low_spread_pct NUMERIC(12,6),

    next_open_reference_price NUMERIC(18,4),
    next_limit_up_price NUMERIC(18,4),
    next_limit_down_price NUMERIC(18,4),

    is_attention BOOLEAN,
    is_disposition BOOLEAN,
    is_full_delivery BOOLEAN,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_market_daily_instrument_date
        UNIQUE (instrument_id, trade_date)
);