INSERT INTO roles (role) VALUES ('Administrator'), ('Manager');

INSERT INTO discounts (type) VALUES ('no discount'),('percentage'),('fixed amount');

INSERT INTO customers (name, email)
VALUES ('Jane Smith', 'jane.smith@gmail.com'),
('Bob Johnson', 'bob.johnson@gmail.com'),
('John Doe', 'john.doe@gmail.com'),
('Jane Doe', 'jane.doe@gmail.com'),
('Bob Smith', 'bob.smith@gmail.com');

INSERT INTO products (name, detail, price)
VALUES ('Apple', 'Red Delicious', 0.99),
('Banana', 'Cavendish', 0.59),
('Orange', 'Navel', 1.29),
('Lemon', 'Eureka', 0.89),
('Mango', 'Tommy Atkins', 1.99),
('Blueberries', 'Fresh', 3.99),
('Kiwi', 'Hayward', 2.49),
('Pineapple', 'Smooth Cayenne', 3.99),
('Strawberries', 'Fresh', 4.99),
('Watermelon', 'Seedless', 5.99);
INSERT INTO users (username, name, roleId)
VALUES ('admin', 'Admin User', 1); -- roleId 1 = Administrator

CREATE EXTENSION pgcrypto;

INSERT INTO auth (username, password)
VALUES ('admin', crypt('password', gen_salt('bf', 10)));

INSERT INTO quotes (quoteNumber, discount, idTypeDiscount, percentageDiscount, discountValue, subtotal, shippingValue, total, sendFrom, sendTo)
VALUES (
  1234, 
  true, 
  2,   -- idTypeDiscount = 2 (percentage)
  10.00, 
  50.00, 
  1000.00, 
  50.00, 
  1000.00, 
  1,   -- sendFrom = users.id 1 (admin)
  2    -- sendTo = customers.id 2 (Bob Johnson)
);
