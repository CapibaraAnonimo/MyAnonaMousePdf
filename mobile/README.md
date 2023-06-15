# MyAnonaMousePDF

FrontEnd mobil hecha en flutter siguiendo el patrón bloc y por paquetes junto a otras librerias.

La aplicación es para uso de usuarios normales y administradores, aunque las acciones que se pueden hacer son de usuario; podras acceder a la selección de libros con todas las opciones que ello implica junto con algunas opciones de perfil.

## Puesta en marcha
Para poner en marcha la aplicación de flutter se puede hacer de multiples maneras pero recomiendo hacerlo de 2, pero primero de nada recuerda encender la API
- Usar un emulador de Android (Recominedo emular un pixel 3a XL con version 33 de API, ya que no requieres tantos recursos como otros dispositivos posteriores para ser emulado e igualmente funciona perfectamente):
  Una vez creado el emulador abrimos el proyecto con visual studio code o tu IDE preferido cambiamos la url de los archivos globals.dart y myanonamousepdf_api_client.dart a ```String baseUrlApi = "http://10.0.2.2:8080/";``` y escribimos el siguiente comando ```flutter run```, elegimos el emulador en lista de dispositivos y se devería de abrir una vez todo esté cargado.
- Usar un movil android:
  Es la opción más comoda ya que no requiere de tantos recursos del ordenador para funcionar correctamente (ya existe una apk generada en `MyAnonaMousePdf\mobile\build\app\outputs\flutter-apk` pero es necesario generar otra con las IPs atualizadas, por favor sigue los comandos que se indican más adelante), como en el caso anterior cambiamos la url de los archivos globals.dart y myanonamousepdf_api_client.dart pero a ```String baseUrlApi = "http://0.0.0.0:8080/";``` cambiando la ip (no el puerto) a la ip de tu red local (puedes mirar la ip escribiendo en una consola el comando ```ipconfig``` en la sección de IPv4), con esto podemos hacer ````fluter run``` y elegit nuestro dispositivo para poder instalar la aplicación; alternativamente podemos ejecutar el comando ```flutter build apk --debug``` para crear la apk, con la que podremos instalarla en nuestro dispositivo. Es importante que el dispositivo esté conectado a la misma red que la API.
