-- Base schema for the LightningEmpire database
-- Supports both PostgreSQL and SQLite with minor adjustments

-- Orders table: Main table for tracking orders from various platforms
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id TEXT,
    platform TEXT,         -- e.g., Uber / Foodpanda
    status TEXT,           -- e.g., pending / dispatched / completed
    amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments table: Tracks financial settlements for each order
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    net_amount DECIMAL(10,2),
    fee DECIMAL(10,2),
    settled_at TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders (id)
);

-- Audit logs table: Records significant actions for traceability
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    action TEXT NOT NULL,      -- e.g., 'ORDER_CREATED', 'PAYMENT_SETTLED'
    details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
