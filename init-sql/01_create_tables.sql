-- Primero: Tablas sin dependencias (roles, discounts, customers, products)
CREATE TABLE roles (
	id SERIAL NOT NULL,
	role VARCHAR(32) NOT NULL UNIQUE,
	PRIMARY KEY(id)
);

CREATE TABLE discounts (
	id SERIAL NOT NULL,
	type VARCHAR(15) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE customers (
	id SERIAL NOT NULL,
	name VARCHAR(65) NOT NULL,
	email VARCHAR(90) NOT NULL UNIQUE,
	active BOOLEAN DEFAULT TRUE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	PRIMARY KEY(id)
);

CREATE TABLE products (
	id SERIAL NOT NULL,
	name VARCHAR(50) NOT NULL,
	detail TEXT NOT NULL,
	price NUMERIC(7,2) NOT NULL,
	active BOOLEAN DEFAULT TRUE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	PRIMARY KEY(id)
);

-- Segundo: users (depende de roles)
CREATE TABLE users (
	id SERIAL NOT NULL,
	username VARCHAR(32) NOT NULL UNIQUE,
	name VARCHAR(65) NOT NULL,
	roleId INT DEFAULT 1,
	active BOOLEAN DEFAULT TRUE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	PRIMARY KEY(id),
	FOREIGN KEY(roleId) REFERENCES roles(id)
);

-- Tercero: auth (depende de users)
CREATE TABLE auth (
	username VARCHAR(32) NOT NULL UNIQUE,
	password VARCHAR(64) NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	PRIMARY KEY(username), -- Corregido: usa username como PK
	FOREIGN KEY(username) REFERENCES users(username) ON UPDATE CASCADE
);

-- Cuarto: quotes (depende de users y customers)
CREATE TABLE quotes (
	id SERIAL NOT NULL,
	quoteNumber INT NOT NULL,
	discount BOOLEAN DEFAULT false,
	idTypeDiscount INT DEFAULT 1,
	percentageDiscount NUMERIC(5,2) DEFAULT 0,
	discountValue NUMERIC(7,2) DEFAULT 0,
	subtotal NUMERIC(7,2) NOT NULL,
	shippingValue NUMERIC(7,2) NOT NULL,
	total NUMERIC(7,2) NOT NULL,
	sendFrom INT NOT NULL,
	sendTo INT NOT NULL,
	sended BOOLEAN DEFAULT false,
	active BOOLEAN DEFAULT true,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	PRIMARY KEY(id),
	FOREIGN KEY(sendFrom) REFERENCES users(id),
	FOREIGN KEY(sendTo) REFERENCES customers(id)
);

-- Quinto: quotes_products (depende de quotes y products)
CREATE TABLE quotes_products (
	idQuote INT NOT NULL,
	idProduct INT NOT NULL,
	amount INTEGER NOT NULL CHECK(amount >= 1),
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	FOREIGN KEY(idQuote) REFERENCES quotes(id),
	FOREIGN KEY(idProduct) REFERENCES products(id)
);
