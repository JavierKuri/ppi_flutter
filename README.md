# ppi_flutter

ppi_flutter is a practice project for a simulated online game shop, made utilizing Flutter + PHP + MySQL. It is an advanced verson of my finalppi repository. The purpose if this repository is to show a way to make a simple online shop using the previously mentioned technologies.

## Installation

It is important to have Flutter, PHP and MySQL in your computer to run this project. 

I made it to run locally utilizing XAMPP as it includes both PHP and MySQL, so one would need to create the database in order for it to work. 

The database includes four tables: usuarios (id_usuario, nombre, correo, contrasena, fecha_nacimiento, direccion), juegos (id_juego, titulo, descripcion, portada, precio, c_almacen, desarrollador, ESRB), carrito (id_carrito, id_usuario, id_juego) and compras (id_compra, id_usuario, id_juego). 



## Usage

To run the Flutter frontend: 
```bash
cd finalppi
flutter run
```

To run the PHP backend: 
```bash
cd backendphp
php -S localhost:8001
```
To start the MySQL database i am utilizing the XAMPP control panel, but starting it on port 3306 like standard through CLI is perfectly valid.
