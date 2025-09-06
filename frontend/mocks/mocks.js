// open server.js
const jsonServer = require('json-server');

// add endpoints
const articulos = require('./articulos');
const pedidos = require('./pedidos');
const products = require('./products');

// add endpoints in router
const router = jsonServer.router({
  pedidos,
  products
});

// start server
const server = jsonServer.create();
const middleware = jsonServer.defaults();

server.use(middleware);

server.use(jsonServer.bodyParser);

server.post('/login', (req, res, next) => {
  if (req.method == 'POST' && req.path == '/login') {
    if (req.body.User === 'a' && req.body.Password === 'a') {
      res.status(200).jsonp({ Token: '321321321312312312' });
    } else {
      res.status(401).json({ message: 'Password o usuario incorrecto' });
    }
  } else {
    next();
  }
});

server.get('/cliente', (req, res, next) => {
  if (req.method == 'GET' && req.path == '/cliente') {
    res.status(200).jsonp({
      CodCli: '150',
      NomCli: 'NOVASOL VARIOS',
      NIF: 'A43366251',
      Telefono: '34 977 677 305',
      EMail: 'novasol@novasolspray.com',
      FormaDePago: '60 días',
      DocumentoDePago: 'GIRO',
      Direccion: {
        Direccion: 'P.I. L’Empalme',
        Poblacion: 'Llorenç del Penedès',
        Provincia: 'Tarragona',
        Pais: 'ESPAÑA'
      },
      DireccionEntrega: {
        Direccion: 'P.I. L’Empalme',
        Poblacion: 'Llorenç del Penedès',
        Provincia: 'Tarragona',
        Pais: 'ESPAÑA',
        Contacto: 'Javier',
        Telefono: '93 123 456 789'
      }
    });
  }
});

server.post('/resetpassword', (req, res, next) => {
  if (req.method == 'POST' && req.path == '/resetpassword') {
    if (req.body.NewPassword && req.body.token) {
      res.status(200).json(true);
    } else {
      res.status(401).json({ message: 'El token no es correcto' });
    }
  } else {
    next();
  }
});

server.post('/articulos', (req, res, next) => {
  if (req.method == 'POST' && req.path == '/articulos') {
    res.status(200).jsonp(articulos);
  }
});

server.post('/pedido', (req, res, next) => {
  if (req.method == 'POST' && req.path == '/pedido') {
    res.status(200).jsonp({
      TipoContable: '1',
      Serie: null,
      Numero: 66797.0,
      Fecha: '15/02/2020',
      Estado: 'PENDIENTE'
    });
  }
});

server.use(router);

server.listen(3000, () => {
  console.log('JSON Server is running');
});
