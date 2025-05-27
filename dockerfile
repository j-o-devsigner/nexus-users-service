FROM node:18-alpine

WORKDIR /app

# Copia solo los archivos de dependencias para aprovechar el caché
COPY package*.json ./
RUN npm install

# Ahora copia el resto del código
COPY . .

# Expón el puerto
EXPOSE 3001

CMD ["node", "index.js"]

