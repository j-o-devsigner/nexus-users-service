-- Set values to null and 0 if there is a update
CREATE OR REPLACE FUNCTION reset_discount_fields() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.discount = false THEN
        NEW.idTypeDiscount := 1;
        NEW.discountValue := 0;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Set discounts trigger
CREATE TRIGGER reset_discount
BEFORE UPDATE ON quotes
FOR EACH ROW
EXECUTE FUNCTION reset_discount_fields();

-- Set update of update_at fields in tables
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Timestamp triggers
CREATE TRIGGER set_timestamp_products
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_quotes
BEFORE UPDATE ON quotes
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_products
BEFORE UPDATE ON quotes_products
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_users
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_auth
BEFORE UPDATE ON auth
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_customers
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();