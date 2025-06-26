# 🏛️ Contrato de Subasta (Auction Smart Contract)

se hizo lo que se pudo :c xd

Un contrato inteligente en Solidity que implementa un sistema de subastas descentralizado con funciones avanzadas de gestión de pujas y depósitos.

## ✨ Características Principales

- **Subastas Temporales**: Cada subasta tiene un tiempo límite definido
- **Extensión Automática**: Si se hace una puja en los últimos 10 minutos, la subasta se extiende automáticamente
- **Incremento Mínimo**: Las pujas deben ser al menos 5% mayores que la anterior
- **Retiros Parciales**: Los usuarios pueden retirar fondos no comprometidos durante la subasta
- **Múltiples Subastas**: Soporte para crear y gestionar múltiples subastas simultáneamente

## 🔧 Funciones Principales

### Para Creadores de Subastas
- `createAuctionItem()` - Crear una nueva subasta
- `finalizeAuction()` - Finalizar manualmente una subasta

### Para Participantes
- `createOffer()` - Realizar una puja
- `withdrawPartial()` - Retirar fondos disponibles
- `getWithdrawableAmount()` - Consultar fondos disponibles para retiro

### Consultas Públicas
- `getAuctionItem()` - Obtener información de una subasta
- `getTimeLeft()` - Tiempo restante de una subasta
- `isAuctionActive()` - Estado de actividad de una subasta

## 🛡️ Seguridad y Validaciones

- Verificación de existencia de subastas
- Validación de incrementos mínimos (5%)
- Control de tiempos de finalización
- Gestión segura de depósitos y retiros
- Prevención de pujas en subastas inactivas

## 📊 Eventos

El contrato emite eventos para tracking:
- `AuctionCreated` - Nueva subasta creada
- `NuevaOferta` - Nueva puja realizada
- `SubastaFinalizada` - Subasta finalizada
- `AuctionExtended` - Subasta extendida
- `PartialWithdraw` - Retiro parcial realizado

## 🚀 Uso Básico

1. **Crear Subasta**: Especifica nombre, precio inicial y duración
2. **Realizar Pujas**: Los usuarios pueden pujar con incrementos mínimos del 5%
3. **Gestionar Fondos**: Retira fondos no comprometidos en subastas activas
4. **Finalización**: Las subastas se finalizan automáticamente al expirar o manualmente por el creador

## ⚙️ Especificaciones Técnicas

- **Versión Solidity**: 0.8.19
- **Licencia**: MIT
- **Red**: Compatible con cualquier red compatible con EVM

---

*Este contrato proporciona una base sólida para sistemas de subastas descentralizadas con características avanzadas de gestión de tiempo y fondos.*
