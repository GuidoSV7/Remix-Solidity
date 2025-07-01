# Documentación del Contrato SubastaSimple

## Estado Inicial de la Subasta

```
Nombre del artículo: Mochila Deportiva
Precio inicial: 1000000000000000 wei (0.001 ETH)
Oferta actual: 0 wei
Ganador actual: 0x0000000000000000000000000000000000000000
Estado: Activa
Tiempo restante: 604788 segundos (~7 días)
```

---

## Funciones Públicas

### **Constructor**
```solidity
constructor(string memory _itemName, uint256 _startingPrice, uint256 _duration)
```
**Descripción:** Inicializa la subasta con nombre del artículo, precio inicial y duración en segundos.

### **ofertar()**
```solidity
function ofertar() external payable onlyActive validBid(msg.value)
```
**Descripción:** Permite hacer una oferta enviando ETH. La oferta debe ser al menos 5% mayor que la actual.

### **mostrarGanador()**
```solidity
function mostrarGanador() external view returns (address winner, uint256 amount)
```
**Descripción:** Devuelve la dirección del ganador actual y el monto de su oferta.

### **mostrarOfertas()**
```solidity
function mostrarOfertas() external view returns (address[] memory addresses, uint256[] memory amounts)
```
**Descripción:** Devuelve arrays con todas las direcciones que han participado y sus últimas ofertas válidas.

### **reembolsoParcial()**
```solidity
function reembolsoParcial() external onlyActive
```
**Descripción:** Permite retirar el exceso de ETH depositado por encima de la última oferta válida durante la subasta.

### **finalizarSubasta()**
```solidity
function finalizarSubasta() external
```
**Descripción:** Finaliza la subasta. Solo el owner puede hacerlo antes del tiempo límite, cualquiera después.

### **informacionSubasta()**
```solidity
function informacionSubasta() external view returns (string memory name, uint256 starting, uint256 current, address winner, bool active, uint256 timeLeft)
```
**Descripción:** Devuelve información completa del estado actual de la subasta.

### **consultarDeposito()**
```solidity
function consultarDeposito(address _user) external view returns (uint256)
```
**Descripción:** Consulta el monto total depositado por un usuario específico.

### **consultarUltimaOferta()**
```solidity
function consultarUltimaOferta(address _user) external view returns (uint256)
```
**Descripción:** Consulta la última oferta válida realizada por un usuario específico.

### **calcularRetiroDisponible()**
```solidity
function calcularRetiroDisponible(address _user) external view returns (uint256)
```
**Descripción:** Calcula cuánto ETH puede retirar un usuario durante la subasta activa.

### **numeroParticipantes()**
```solidity
function numeroParticipantes() external view returns (uint256)
```
**Descripción:** Devuelve el número total de participantes únicos en la subasta.

### **balanceContrato()**
```solidity
function balanceContrato() external view returns (uint256)
```
**Descripción:** Devuelve el balance total de ETH almacenado en el contrato.

### **emergencia()**
```solidity
function emergencia() external onlyOwner
```
**Descripción:** Función de emergencia que permite al owner retirar todos los fondos 30 días después del fin programado.

---

## Variables de Estado

### **owner**
```solidity
address public owner
```
**Descripción:** Dirección del propietario del contrato (quien lo desplegó).

### **itemName**
```solidity
string public itemName
```
**Descripción:** Nombre del artículo en subasta.

### **startingPrice**
```solidity
uint256 public startingPrice
```
**Descripción:** Precio inicial de la subasta en wei.

### **endTime**
```solidity
uint256 public endTime
```
**Descripción:** Timestamp Unix cuando termina la subasta.

### **isActive**
```solidity
bool public isActive
```
**Descripción:** Indica si la subasta está activa o finalizada.

### **currentWinner**
```solidity
address public currentWinner
```
**Descripción:** Dirección del ganador actual de la subasta.

### **winningBid**
```solidity
uint256 public winningBid
```
**Descripción:** Monto de la oferta ganadora actual en wei.

### **deposits**
```solidity
mapping(address => uint256) public deposits
```
**Descripción:** Mapeo que almacena el total de ETH depositado por cada dirección.

### **lastValidBid**
```solidity
mapping(address => uint256) public lastValidBid
```
**Descripción:** Mapeo que almacena la última oferta válida de cada dirección.

### **bidders**
```solidity
address[] public bidders
```
**Descripción:** Array que contiene todas las direcciones que han participado en la subasta.

### **hasBidded**
```solidity
mapping(address => bool) public hasBidded
```
**Descripción:** Mapeo que indica si una dirección ya ha participado en la subasta.

---

## Constantes

### **COMMISSION_RATE**
```solidity
uint256 public constant COMMISSION_RATE = 2
```
**Descripción:** Tasa de comisión del 2% aplicada a los reembolsos.

### **MIN_INCREMENT**
```solidity
uint256 public constant MIN_INCREMENT = 5
```
**Descripción:** Incremento mínimo del 5% requerido para nuevas ofertas.

### **EXTENSION_TIME**
```solidity
uint256 public constant EXTENSION_TIME = 10 minutes
```
**Descripción:** Tiempo de extensión automática cuando se hace una oferta en los últimos 10 minutos.

---

## Eventos

### **NuevaOferta**
```solidity
event NuevaOferta(address indexed bidder, uint256 amount, uint256 newEndTime)
```
**Descripción:** Se emite cuando se realiza una nueva oferta válida.

### **SubastaFinalizada**
```solidity
event SubastaFinalizada(address indexed winner, uint256 winningAmount, uint256 timestamp)
```
**Descripción:** Se emite cuando la subasta es finalizada.

### **Reembolso**
```solidity
event Reembolso(address indexed bidder, uint256 amount)
```
**Descripción:** Se emite cuando se procesa un reembolso a un participante.

---

## Modificadores

### **onlyOwner**
```solidity
modifier onlyOwner()
```
**Descripción:** Restringe el acceso solo al propietario del contrato.

### **onlyActive**
```solidity
modifier onlyActive()
```
**Descripción:** Permite ejecución solo cuando la subasta está activa y no ha terminado.

### **validBid**
```solidity
modifier validBid(uint256 _amount)
```
**Descripción:** Valida que una oferta cumpla con los requisitos mínimos de incremento.
