// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SimpleDEX is ReentrancyGuard {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;
    
    uint256 public reserveA;
    uint256 public reserveB;
    
    // Eventos
    event LiquidityAdded(uint256 amountA, uint256 amountB);
    event TokensSwapped(address indexed user, address fromToken, address toToken, uint256 amountIn, uint256 amountOut);
    event LiquidityRemoved(uint256 amountA, uint256 amountB);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el owner puede ejecutar");
        _;
    }
    
    
    constructor(address _tokenA, address _tokenB) {
        require(_tokenA != address(0) && _tokenB != address(0), "Direcciones invalidas");
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }
    

    function addLiquidity(uint256 amountA, uint256 amountB) external onlyOwner nonReentrant {
        require(amountA > 0 && amountB > 0, "Cantidades deben ser mayor a 0");
        
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Fallo TokenA");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Fallo TokenB");
        
        reserveA += amountA;
        reserveB += amountB;
        
        emit LiquidityAdded(amountA, amountB);
    }
    
 
    function swapAforB(uint256 amountAIn) external nonReentrant {
        require(amountAIn > 0, "Cantidad debe ser mayor a 0");
        require(reserveA > 0 && reserveB > 0, "No hay liquidez disponible");
 
        uint256 amountBOut = (reserveB * amountAIn) / (reserveA + amountAIn);
        require(amountBOut > 0, "Output insuficiente");
        require(amountBOut < reserveB, "Liquidez insuficiente");
        
        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "Fallo en ingreso A");
        require(tokenB.transfer(msg.sender, amountBOut), "Fallo en retiro B");
        
        reserveA += amountAIn;
        reserveB -= amountBOut;
        
        emit TokensSwapped(msg.sender, address(tokenA), address(tokenB), amountAIn, amountBOut);
    }
    

    function swapBforA(uint256 amountBIn) external nonReentrant {
        require(amountBIn > 0, "Cantidad debe ser mayor a 0");
        require(reserveA > 0 && reserveB > 0, "No hay liquidez disponible");
        

        uint256 amountAOut = (reserveA * amountBIn) / (reserveB + amountBIn);
        require(amountAOut > 0, "Output insuficiente");
        require(amountAOut < reserveA, "Liquidez insuficiente");
        
        require(tokenB.transferFrom(msg.sender, address(this), amountBIn), "Fallo en ingreso B");
        require(tokenA.transfer(msg.sender, amountAOut), "Fallo en retiro A");
        
        reserveB += amountBIn;
        reserveA -= amountAOut;
        
        emit TokensSwapped(msg.sender, address(tokenB), address(tokenA), amountBIn, amountAOut);
    }
    
  
    function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner nonReentrant {
        require(amountA > 0 && amountB > 0, "Cantidades deben ser mayor a 0");
        require(amountA <= reserveA && amountB <= reserveB, "Reservas insuficientes");
        
        require(tokenA.transfer(msg.sender, amountA), "Fallo TokenA");
        require(tokenB.transfer(msg.sender, amountB), "Fallo TokenB");
        
        reserveA -= amountA;
        reserveB -= amountB;
        
        emit LiquidityRemoved(amountA, amountB);
    }
    

    function getPrice(address _token) external view returns (uint256) {
        require(_token == address(tokenA) || _token == address(tokenB), "Token no soportado");
        require(reserveA > 0 && reserveB > 0, "No hay liquidez disponible");
        
        if (_token == address(tokenA)) {
            return (reserveB * 1e18) / reserveA;
        } else {
            return (reserveA * 1e18) / reserveB;
        }
    }
    
  
    function simulateSwap(address tokenIn, uint256 amountIn) external view returns (uint256 amountOut) {
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Token invalido");
        require(amountIn > 0, "Cantidad debe ser mayor a 0");
        require(reserveA > 0 && reserveB > 0, "No hay liquidez disponible");
        
        if (tokenIn == address(tokenA)) {
            // (reserveA + amountIn)(reserveB - amountOut) = reserveA * reserveB
            amountOut = (reserveB * amountIn) / (reserveA + amountIn);
        } else {
            // (reserveB + amountIn)(reserveA - amountOut) = reserveA * reserveB
            amountOut = (reserveA * amountIn) / (reserveB + amountIn);
        }
    }
}
