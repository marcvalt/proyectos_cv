Colección de programas y scripts que he desarrollado y considero interesantes para mostrar en mi Currículum.

## Path of Exile Scripts

Contiene una serie scripts programados para automatizar tareas repetitivas en el juego Path of Exile, utilizando lenguajes como **AutoHotKey (AHK)** y **Python**, para optimizar procesos como gestión de inventario y recolección de items. Además de mejorar la experiencia de juego, algunos fueron vendidos a otros jugadores.

Cada carpeta incluye un README con una breve descripción de lo que hace cada script.

### Requisitos
- **AutoHotKey v1.1**
- **Python 3.11**
- Dependencias listadas en `requirements.txt` para aquellos programas escritos en python

## Wallapop, bot de búsqueda

Programa para buscar productos específicos en Wallapop de forma automática y continua. Cuando encuentra un producto que coincide con tus criterios de búsqueda, envía una notificación al móvil a través de Telegram.

Para configurar los parámetros de búsqueda, edita la variable `PARAMS`. Además de los incluidos en el programa, puedes usar otros filtros como:

```yaml
"is_shippable": true
"condition": "as_good_as_new"
"order_by": "newest"
"country_code": "ES"
"min_sale_price": 10
"max_sale_price": 100
```

La configuración del bot de Telegram (token y chat ID) debe realizarse en el archivo `.env`, con el siguiente formato:

```yaml
  BOT_TOKEN = "123456789:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"
  CHAT_ID = "123456789"
```

### Requisitos
- **Python 3.11**
- Bot en **Telegram** configurado
- Dependencias listadas en `requirements.txt`

## Generador de tabla HTML para Minecraft desde archivos MCA

Programa para extraer información de carteles de minecraft, a partir de archivos MCA, que contienen datos de secciones del mundo del juego. Está diseñado para un servidor de Minecraft que quería mostrar todas las tiendas del juego en una página web mediante una tabla.

La configurar del servidor [filebrowser](https://github.com/filebrowser/filebrowser) es en el archivo `.env`, con el siguiente formato:

```yaml
  API_URL = "https://example.com/api"
  USERNAME = "admin"
  PASSWORD = "password"
```

La carpeta `examples` contiene ejemplos de los diferentes tipos de archivos generados por el programa: carteles en crudo, en JSON y en la tabla HTML final.

### Requisitos
- **Python 3.11**
- [NBTExplorer](https://github.com/jaquadro/NBTExplorer). Lectura de archivos MCA.
- [filebrowser-upload](https://github.com/guyskk/filebrowser-upload). Subir archivos a [filebrowser](https://github.com/filebrowser/filebrowser).
- Dependencias listadas en `requirements.txt`
