const evolutionMetalizada = require('./articulos/evolution-metalizada');
const basicSintetica = require('./articulos/basic-sintetica');
const basicFluorescente = require('./articulos/basic-fluorescente');

module.exports = [
  {
    id: 1,
    brand: 'Evolution',
    family: 'Evolution Metalizada',
    presentation: ['520 cc'],
    colorTypes: ['Metalizada'],
    products: evolutionMetalizada,
    total: evolutionMetalizada.length,
    image: ''
  },
  {
    id: 2,
    brand: 'Basic',
    family: 'Basic sintética',
    presentation: ['270 cc', '520cc'],
    colorTypes: ['Brillo', 'Mate'],
    products: basicSintetica,
    total: basicSintetica.length,
    image: ''
  },
  {
    id: 3,
    brand: 'Basic',
    family: 'Basic sintética',
    presentation: ['270 cc', '520cc'],
    colorTypes: ['Brillo'],
    products: basicFluorescente,
    total: basicFluorescente.length,
    image: ''
  }
];
