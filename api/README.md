# MyAnonaMousePDF
API de una aplicación de difusión de libros hecha en SpringBoot con java 17, base de datos h2/postgresql, 
documentación de los endpoits con OpenApi 3.0 + Swagger-ui (**[url para la visualización de swagger](http://localhost:8080/swagger-ui/index.html#/)**), 
además de algunas librerías extras usadas en la API.

La API cuenta con 2 perfiles, dev y test, siendo la mayor diferencia entre ellos la base de datos que usa, siendo en dev h2 y en test postgres; en los siguientes puntos se explicarán los pasos a seguir para poner en funcionamineto la API.

La API corre en http://localhost:8080.

## DEV
Para poner en marcha el perfil dev es tan sencillo como cambiar el perfil en el archivo application.properties a dev.
```
spring.profiles.active=dev
```

## TEST
Para poner en marcha el perfil test será necesario primero tener instalado docker, ya que necesitaremos  correr el archivo docker-compose.yml que se encuentra en la misma carpeta que este README.md. 
Para ello, en un terminal ponte en esta carpeta y ejecuta el siguiente comando (opcionalmente puedes añadir la opción -d con la que pones el contenedor a modo de servicio y no podras seguir usando esa terminal):
```
docker-compose up
```
Una vez arrancado el contenedor ya podremos cambiar el perfil a test y poner en marcha la API con normalidad.
```
spring.profiles.active=test
```

## Usuarios
```
Admin: 'admin' - Contraseña : 'admin'
Usuario: 'user' - Contraseña : 'user'
Usuario: 'adrian.arnaiz' - Contraseña : 'qwerty'
Usuario: 'profesor.luismi' - Contraseña : 'profesor'
Usuario: 'profesor.miguel' - Contraseña : 'profesor'
```

## FrontEnd
Para poder usar la API necesitaras usar postman, flutter o angular ya que la gran mayoría de los endpoints tienen autenticación por token.
### Postman
Para usar postman debes importar el archivo de postman que se encuentra en esta carpeta desde postman y desde ahí podras acceder a la gran mayoría de los endpints 
(los que no son endpoints que no han llegado a aplicarse en ninguna de las dos aplicacines que incorporan la API.
### Flutter
Para flutter ver README.md de la carpeta mobile
### Angular
Para Angular ver README.md de la carpeta web
