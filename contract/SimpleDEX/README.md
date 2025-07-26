# 🚀 SimpleDEX - Exchange Descentralizado

Un exchange descentralizado (DEX) simple implementado en Solidity que permite el intercambio de dos tokens ERC-20 utilizando pools de liquidez y la fórmula del producto constante.

## 🌐 Contratos Deployados en Ethereum Sepolia

| Contrato | Dirección | Explorer |
|----------|-----------|----------|
| **TokenA** | `0xd93427d2Bd09E1E86A8251Efb08E954856705622` | [Ver en Etherscan](https://sepolia.etherscan.io/address/0xd93427d2Bd09E1E86A8251Efb08E954856705622) |
| **TokenB** | `0x340dE57436cAcDc876a25039fEBF95e95Cab35E3` | [Ver en Etherscan](https://sepolia.etherscan.io/address/0x340dE57436cAcDc876a25039fEBF95e95Cab35E3) |
| **SimpleDEX** | `0x3A1c671EbD69fa378dFd9A83483A089E08007a05` | [Ver en Etherscan](https://sepolia.etherscan.io/address/0x3A1c671EbD69fa378dFd9A83483A089E08007a05) |

## 📋 Descripción del Proyecto

SimpleDEX es una implementación básica de un Automated Market Maker (AMM) que:
- Mantiene un pool de liquidez para dos tokens ERC-20 (TokenA y TokenB)
- Utiliza la fórmula del producto constante `(x + dx)(y - dy) = xy` para calcular precios
- Permite añadir y retirar liquidez
- Facilita intercambios bidireccionales entre tokens

## 🏗️ Arquitectura

### Contratos Implementados

#### 1. TokenA
```solidity
contract TokenA is ERC20 {
    constructor(uint256 initialSupply) ERC20("TokenA", "TKA")
}
```
- **Nombre**: TokenA
- **Símbolo**: TKA
- **Decimales**: 18
- **Supply inicial**: 1,000,000 tokens

#### 2. TokenB
```solidity
contract TokenB is ERC20 {
    constructor(uint256 initialSupply) ERC20("TokenB", "TKB")
}
```
- **Nombre**: TokenB
- **Símbolo**: TKB
- **Decimales**: 18
- **Supply inicial**: 1,000,000 tokens

#### 3. SimpleDEX
Contrato principal que implementa la funcionalidad DEX con las siguientes características:
- **Owner-only**: Solo el propietario puede añadir/retirar liquidez
- **Reentrancy protection**: Protección contra ataques de reentrancy
- **Constant product formula**: Implementa `(x + dx)(y - dy) = xy`

## 🔧 Funcionalidades

### Funciones Principales

| Función | Descripción | Acceso |
|---------|-------------|---------|
| `addLiquidity(uint256 amountA, uint256 amountB)` | Añade liquidez al pool | Solo Owner |
| `swapAforB(uint256 amountAIn)` | Intercambia TokenA por TokenB | Público |
| `swapBforA(uint256 amountBIn)` | Intercambia TokenB por TokenA | Público |
| `removeLiquidity(uint256 amountA, uint256 amountB)` | Retira liquidez del pool | Solo Owner |
| `getPrice(address _token)` | Obtiene el precio de un token | View |

### Funciones Auxiliares

| Función | Descripción | Tipo |
|---------|-------------|------|
| `getReserves()` | Obtiene las reservas actuales | View |
| `simulateSwap(address tokenIn, uint256 amountIn)` | Simula un swap sin ejecutarlo | View |

## 📊 Fórmula Matemática

SimpleDEX utiliza la **fórmula del producto constante**:

```
(x + dx)(y - dy) = xy
```

Donde:
- `x, y` = reservas actuales de TokenA y TokenB
- `dx` = cantidad de entrada
- `dy` = cantidad de salida

### Cálculo de Output:
```
amountOut = (reserveOut × amountIn) / (reserveIn + amountIn)
```

## 🛡️ Características de Seguridad

- **ReentrancyGuard**: Previene ataques de reentrancy
- **Access Control**: Solo el owner puede gestionar liquidez
- **Input Validation**: Validación de parámetros de entrada
- **Balance Checks**: Verificación de balances y allowances
- **Overflow Protection**: Uso de Solidity 0.8.20+ con protección automática

## 📚 Eventos

```solidity
event LiquidityAdded(uint256 amountA, uint256 amountB);
event TokensSwapped(address indexed user, address fromToken, address toToken, uint256 amountIn, uint256 amountOut);
event LiquidityRemoved(uint256 amountA, uint256 amountB);
```

## 🚀 Deployment

### Pre-requisitos
- Remix IDE o Hardhat
- MetaMask configurado con Ethereum Sepolia
- ETH en Ethereum Sepolia para gas

### Pasos de Deployment

1. **Deploy TokenA**
   ```
   Constructor: 1000000000000000000000000 (1M tokens)
   ```

2. **Deploy TokenB**
   ```
   Constructor: 1000000000000000000000000 (1M tokens)
   ```

3. **Deploy SimpleDEX**
   ```
   Constructor: 
   - _tokenA: [Dirección de TokenA]
   - _tokenB: [Dirección de TokenB]
   ```

## 🧪 Testing

### Flujo de Pruebas

1. **Verificar Deployments**
   - Confirmar balances iniciales
   - Verificar configuración de SimpleDEX

2. **Añadir Liquidez**
   ```solidity
   // Aprobar tokens
   tokenA.approve(simpleDEX, amount);
   tokenB.approve(simpleDEX, amount);
   
   // Añadir liquidez
   simpleDEX.addLiquidity(10000e18, 5000e18);
   ```

3. **Realizar Swaps**
   ```solidity
   // Swap A→B
   simpleDEX.swapAforB(1000e18);
   
   // Swap B→A  
   simpleDEX.swapBforA(500e18);
   ```

4. **Verificar Funcionamiento**
   - Comprobar cambios en reservas
   - Validar balances de usuarios
   - Verificar precios dinámicos

## 📄 Contratos Verificados

### Ethereum Sepolia Testnet

| Contrato | Dirección | Estado |
|----------|-----------|---------|
| TokenA | `0xd93427d2Bd09E1E86A8251Efb08E954856705622` | ✅ Verificado |
| TokenB | `0x340dE57436cAcDc876a25039fEBF95e95Cab35E3` | ✅ Verificado |
| SimpleDEX | `0x3A1c671EbD69fa378dFd9A83483A089E08007a05` | ✅ Verificado |

## 💡 Casos de Uso

### Ejemplo de Liquidez
```
Liquidez inicial: 10,000 TokenA + 5,000 TokenB
Ratio inicial: 1 TokenA = 0.5 TokenB
```

### Ejemplo de Swap
```
Input: 1,000 TokenA
Output: ~454 TokenB (aproximado, según fórmula)
Nuevo ratio: Precio de TokenA aumenta
```

## ⚠️ Limitaciones

- **Liquidez limitada**: Solo el owner puede añadir liquidez
- **Sin fees**: No implementa comisiones de trading
- **Pool único**: Solo maneja un par de tokens
- **Sin slippage protection**: Los usuarios deben calcular slippage manualmente

## 🛠️ Tecnologías Utilizadas

- **Solidity**: ^0.8.20
- **OpenZeppelin**: Contratos estándar y seguridad
- **Remix IDE**: Desarrollo y testing
- **Scroll Sepolia**: Red de testing
- **MetaMask**: Interacción con blockchain

## 📈 Mejoras Futuras

- [ ] Implementar LP tokens para múltiples proveedores de liquidez
- [ ] Añadir fees de trading
- [ ] Protección contra slippage
- [ ] Multiple pools
- [ ] Router para swaps multi-hop
- [ ] Interface web (frontend)

## 👨‍💻 Autor

Proyecto desarrollado como parte del trabajo final del curso de Solidity.

## 📄 Licencia

MIT License - Ver archivo LICENSE para más detalles.

---

## 🎯 Resultados de Testing

### ✅ Funcionalidades Probadas
- [x] Deploy exitoso de todos los contratos
- [x] Añadir liquidez correctamente
- [x] Swaps A→B funcionando
- [x] Swaps B→A funcionando  
- [x] Fórmula del producto constante aplicada
- [x] Precios dinámicos actualizándose
- [x] Restricciones de acceso funcionando
- [x] Validaciones de input operativas
- [x] Eventos emitidos correctamente

### 📊 Métricas de Ejemplo
```
Reservas iniciales: (10,000 TokenA, 5,000 TokenB)
Swaps realizados: 5+ transacciones exitosas
Gas usado promedio: ~150,000 gas por swap
Precisión matemática: ✅ Fórmula exacta
```

---

*🚀 SimpleDEX - Un DEX simple pero funcional desarrollado en Solidity*
